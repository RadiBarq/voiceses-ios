//
//  CalendarSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 28/10/2021.
//

import Foundation
import Combine
import SwiftUI

class CalendarViewModel: ObservableObject {
    let minYear = 2020
    @Published var selectedDate = Date.now {
        didSet {
            selectedYear = calendar!.component(.year, from: selectedDate)
            guard let prevMonthDate = calendar!.date(
                byAdding: .month,
                value: -1,
                to: selectedDate), let nextMonthDate = calendar!.date(
                    byAdding: .month,
                    value: 1,
                    to: selectedDate)
            else { return }
            isNextButtonDisabled = calendar!.component(.year, from: nextMonthDate) > calendar!.component(.year, from: Date.now)
            isPreviousButtonDisabled = calendar!.component(.year, from: prevMonthDate) < minYear
        }
    }
    
    @Published var selectedYear: Int = 2021
    @Published var isNextButtonDisabled: Bool = false
    @Published var isPreviousButtonDisabled: Bool = false
    @Published var title: String = ""
    @Published var alertMessage = ""
    @Published var showingAlert = false
    @Published var dates = [String: [Card]]()
    @Published var color = Color.primary
    
    private(set) var calendar: Calendar?
    private(set) var monthFormatter: DateFormatter?
    private(set) var dayFormatter: DateFormatter?
    private(set) var weekDayFormatter: DateFormatter?
    private(set) var defaultFormatter: DateFormatter?
    private var firebaseGetAddedCalendarCardsService: FirebaseGetAddedCalendarCardsService?
    private var firebaseGetDeletedCalendarCardsService: FirebaseGetDeletedCalendarCardsService?
    private var subscriptions = Set<AnyCancellable>()
    
    func setup(with calendar: Calendar) {
        if self.calendar == nil {
            self.calendar = calendar
            self.selectedYear = calendar.component(.year, from: Date.now)
            self.monthFormatter = DateFormatter.getMonthFormatter(for: calendar)
            self.dayFormatter = DateFormatter.getDayFormatter(for: calendar)
            self.weekDayFormatter = DateFormatter.getWeekDayFormatter(for: calendar)
            self.defaultFormatter = DateFormatter.getDefaultFormatter()
        }
        
        if firebaseGetDeletedCalendarCardsService == nil {
            self.firebaseGetDeletedCalendarCardsService = FirebaseGetDeletedCalendarCardsService(year: selectedYear)
            self.startListenToDeletedCards()
        }
        
        if firebaseGetAddedCalendarCardsService == nil {
            self.firebaseGetAddedCalendarCardsService = FirebaseGetAddedCalendarCardsService(year: selectedYear)
            self.startListenToAddedCards()
        }
    }
    
    func areCardsAddedTo(date: Date) -> Bool {
        let dateString = date.getCurrentDateAsString()
        if dates[dateString] != nil {
            return true
        } else {
            return false
        }
    }
    
    func getCardsFor(date: Date) -> [Card] {
        let dateString = date.getCurrentDateAsString()
        return dates[dateString] ?? []
    }
    
    func set(selectedDate: Date) {
        subscriptions = Set<AnyCancellable>()
        let newDateYear = calendar!.component(.year, from: selectedDate)
        let currentDateYear = calendar!.component(.year, from: self.selectedDate)
        if newDateYear != currentDateYear {
            self.firebaseGetDeletedCalendarCardsService = FirebaseGetDeletedCalendarCardsService(year: newDateYear)
            self.startListenToDeletedCards()
            self.firebaseGetAddedCalendarCardsService = FirebaseGetAddedCalendarCardsService(year: newDateYear)
            self.startListenToAddedCards()
        }
        self.selectedDate = selectedDate
    }
    
    private func startListenToAddedCards() {
        firebaseGetAddedCalendarCardsService?
            .cards?
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                if case let .failure(error) = completion {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { [weak self] card in
                guard let weakSelf = self else { return }
                if weakSelf.dates[card.dateCreated] != nil {
                    var cards = weakSelf.dates[card.dateCreated]!
                    cards.append(card)
                    weakSelf.dates[card.dateCreated] = cards
                } else {
                    weakSelf.dates[card.dateCreated] = [card]
                }
            })
            .store(in: &subscriptions)
    }
    
    private func startListenToDeletedCards() {
        firebaseGetDeletedCalendarCardsService?.deletedCards?
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                if case let .failure(error) = completion {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { [weak self] card in
                guard let weakSelf = self,  weakSelf.dates[card.dateCreated] != nil,
                      var cards = weakSelf.dates[card.dateCreated]
                else { return }
                cards.removeAll(where: { card in
                    card.id == card.id
                })
                weakSelf.dates[card.dateCreated] = cards.isEmpty ? nil : cards
            })
            .store(in: &subscriptions)
    }
}
