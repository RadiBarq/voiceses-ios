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
    @Published var cards = [Card]()
    @Published var showingAddNewCardScene = false
    @Published var showingAddNewSubjectScene = false
    @Published var showingTestScene = false
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
    
    @Published var allCards = [Card]()
    
    // Test related publishers
    @Published var testCards = [Card]()
    
    @Published var showsTestResultScreen = false
    @Published var testResult: Double = 0.0
    @Published var test: Test?
    
    private var subscriptions = Set<AnyCancellable>()
    private var getCardsService: FirebaseGetCardsService!
    private var deleteCardService = FirebaseDeleteACardService()
    private var updateSubjectService = FirebaseUpdateSubjectService()
    private var firebaseDeleteCalendarCardService = FirebaseDeleteCalendarCardService()
    
    init() {
        deleteCardService = FirebaseDeleteACardService()
        updateSubjectService = FirebaseUpdateSubjectService()
    }
    
    func deleteCard(with id: String, date: String, for subject: Subject) {
        var subjectCopy = subject
        deleteCardService.deleteCard(with: id, subjectID: subject.id!)
        firebaseDeleteCalendarCardService.deleteCard(with: id, for: date)
        subjectCopy.numberOfCards! -= 1
        updateSubjectService.updateNumberOfCards(for: subjectCopy)
        GlobalService.shared.deleteCardImages(with: id, subjectID: subjectCopy.id!)
    }
    
    func reverseCards() {
        sortOptions.toggle()
    }
    
    func startListenToGetCards(for subject: Subject) {
        getCardsService = FirebaseGetCardsService(subjectID: subject.id!)
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
            startDate = .startOfToday
            endDate = .endOfToday
        case .last7Days:
            startDate = .startOfSevenDaysAgo
            endDate = .endOfToday
        case .last30Days:
            startDate = .startOfThirtyDaysAgo
            endDate = .endOfToday
        case .customDate:
            startDate = filterStartDate
            endDate = filterEndDate
        }
        return (startDate.timestamp, endDate.timestamp)
    }
}
