//
//  LecturesSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 25/04/2021.
//

import Foundation
import Combine
import PencilKit
import SwiftUI

final class CardsViewModel: ObservableObject {
    var title: String {
        subject.title
    }
    var subject: Subject
    @Published var cards = [Card]()
    @Published var showingAddNewCardScene = false
    @Published var showingAddNewSubjectScene = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showingFilterCardsScene = false
    @Published var showingSetupTestScene = false
    @Published var filterStartDate = Date.startOfYesterday
    @Published var filterEndDate = Date.endOfToday
    @Published var selectedDateFilterOption = DateFilterOption.today
    @Published var sortOptions = SortOptions.ascend {
        didSet {
            cards.reverse()
        }
    }
    @Published var isFilterApplied = false {
        didSet {
            if isFilterApplied {
                let (startDate, endDate) = self.getFirstAndEndTimestamps()
                cards = allCards.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
            } else {
                cards = allCards
            }
        }
    }
    
    private var allCards = [Card]()
    private var subscriptions = Set<AnyCancellable>()
    private var getCardsService: FirebaseGetCardsService
    private var deleteCardService: FirebaseDeleteACardService
    private var updateSubjectService: FirebaseUpdateSubjectService
    
    init(subject: Subject) {
        self.subject = subject
        getCardsService = FirebaseGetCardsService(subjectID: subject.id!)
        deleteCardService = FirebaseDeleteACardService()
        updateSubjectService = FirebaseUpdateSubjectService()
        startListenToGetCardsService()
    }
    
    func deleteCard(with id: String) {
        deleteCardService.deleteCard(with: id, subjectID: subject.id!)
        subject.numberOfCards! -= 1
        updateSubjectService.updateNumberOfCards(for: subject)
        GlobalService.shared.deleteCardImages(with: id, subjectID: subject.id!)
    }
    
    func reverseCards() {
        sortOptions.toggle()
    }
    
    private func startListenToGetCardsService() {
        getCardsService
            .cards?
            .replaceError(with: [])
            .map { [weak self] in
                guard let weakSelf = self else { return [] }
                if weakSelf.isFilterApplied {
                    let (startDate, endDate) = weakSelf.getFirstAndEndTimestamps()
                    return $0.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
                } else {
                    return $0
                }
            }
            .assign(to: \.cards, on: self)
            .store(in: &subscriptions)
        
        getCardsService
            .cards?
            .replaceError(with: [])
            .assign(to: \.allCards, on: self)
            .store(in: &subscriptions)
        
        getCardsService
            .cards?
            .ignoreOutput()
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else { return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
    
    private func getFirstAndEndTimestamps() -> (Int64, Int64) {
        var startDate: Date
        var endDate: Date
        switch selectedDateFilterOption {
        case .today:
            startDate = Date.startOfToday
            endDate = Date.endOfToday
        case .last7Days:
            startDate = Date.startOfSevenDaysAgo
            endDate = Date.endOfToday
        case .last30Days:
            startDate = Date.startOfThirtyDaysAgo
            endDate = Date.endOfToday
        case .customDate:
            startDate = filterStartDate
            endDate = filterEndDate
        }
        return (startDate.timestamp, endDate.timestamp)
    }
}