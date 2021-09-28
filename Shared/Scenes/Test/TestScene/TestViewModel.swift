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
    @Published var testCards = [Card]()
    var allTestCards = [Card]()
    private var addNewTestService = FirebaseAddNewTestService()
    private var updateCardService = FirebaseUpdateCardService()
    private var subscriptions = Set<AnyCancellable>()
    
    // This should be moved to be global in the future
    func isFrontCard(card: Card) -> Bool {
        return card.id == (testCards.last?.id ?? "0")
    }
    
    func addCorrectAnswer(card: Card) {
        correctCards.append(card)
    }
    
    func addWrongAnswer(card: Card) {
        wrongCards.append(card)
    }
    
    func addTestResult(subjectID: String,
                       isPresented: Binding<Bool>,
                       showsTestResultScene: Binding<Bool>,
                       test: Binding<Test?>) {
        let timestamp = Date.currentTimeStamp
        let dateCreated = Date().getCurrentDateWithTimeAsString()
        let testScore = (Double(correctCards.count) / Double(allTestCards.count)) * 100
        let currentTest = Test(id: nil, subjectID: subjectID, allCards: allTestCards, correctCards: correctCards, wrongCards: wrongCards, dateCreated: dateCreated, timestamp: timestamp, score: testScore)
        test.wrappedValue = currentTest
        addNewTestService.addNewTest(test: currentTest)
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else {
                    return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
                self?.updateCorrectCardsScore()
                self?.updateWrongCardsScore()
                isPresented.wrappedValue.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() +  0.3) {
                    showsTestResultScene.wrappedValue.toggle()
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
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
