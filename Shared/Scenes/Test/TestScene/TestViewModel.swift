//
//  TestModel.swift
//  Voiceses
//
//  Created by Radi Barq on 25/07/2021.
//

import Foundation
import Combine
import SwiftUI

class TestViewModel: ObservableObject {
    @Published var showingFlipButton = true
    @Published var showingCorrectAndWrongButtons = false
    @Published var cardSide: CardSide = .front
    @Published var nextAnimation: CardSide = .front
    @Published var currentCard = 1
    @Published var testCardsCount: Int?
    @Published var isCorrectAndWrongButtonsDisabled = true
    @Published var correctCards = [Card]()
    @Published var wrongCards = [Card]()
    @Published var showingAlert = false
    @Published var alertMessage = ""
    var testCards = [Card]()
    private var addNewTestService = FirebaseAddNewTestService()
    private var updateCardService = FirebaseUpdateCardService()
    private var subscriptions = Set<AnyCancellable>()
    
    // This should be moved to be global in the future
    func isFrontCard(card: Card, cards: [Card]) -> Bool {
        return card.id == (cards.last?.id ?? "0")
    }
    
    func addCorrectAnswer(card: Card) {
        correctCards.append(card)
    }
    
    func addWrongAnswer(card: Card) {
        wrongCards.append(card)
    }
    
    func addTestResult(subjectID: String) {
        let timestamp = Date.currentTimeStamp
        let dateCreated = Date().getCurrentDateWithTimeAsString()
        let test = Test(id: nil, subjectID: subjectID, allCards: testCards, correctCards: correctCards, wrongCards: wrongCards, dateCreated: dateCreated, timestamp: timestamp)
        addNewTestService.addNewTest(test: test)
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else {
                    return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
        updateCorrectCardsScore()
        updateWrongCardsScore()
    }
    
    private func updateCorrectCardsScore() {
        for card in correctCards {
            var copyCard = card
            copyCard.testScore += 1
            updateCardService.updateTestScore(for: copyCard)
        }
    }
    
    private func updateWrongCardsScore() {
        for card in wrongCards {
            var copyCard = card
            copyCard.testScore -= 1
            updateCardService.updateTestScore(for: copyCard)
        }
    }
}
