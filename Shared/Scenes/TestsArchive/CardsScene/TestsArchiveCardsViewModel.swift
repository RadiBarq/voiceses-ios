//
//  TestsArchiveCardsScene.swift
//  TestsArchiveCardsScene
//
//  Created by Radi Barq on 06/09/2021.
//

import Foundation
import Combine

class TestsArchiveCardsViewModel: ObservableObject {
    @Published var cards = [Card]()
    @Published var testsArchiveCardsFilter: TestsArchiveCardsFilter = .allCards {
        didSet {
            switch testsArchiveCardsFilter {
            case .allCards:
                cards = allCards
            case .correctCards:
                cards = correctCards
            case .wrongCards:
                cards = wrongCards
            }
        }
    }
    
    private var correctCards = [Card]()
    private var wrongCards = [Card]()
    private var allCards = [Card]()
    private let getTestCardsService = FirebaseGetTestCardsService()
    private var subscriptions = Set<AnyCancellable>()
    func populateCards(for subjectID: String, with testID: String) {
        getTestCardsService
            .getCards(for: subjectID, with: testID, filterBY: .correctCards)
            .replaceError(with: [])
            .assign(to: \.correctCards, on: self)
            .store(in: &subscriptions)
        getTestCardsService
            .getCards(for: subjectID, with: testID, filterBY: .wrongCards)
            .replaceError(with: [])
            .assign(to: \.wrongCards, on: self)
            .store(in: &subscriptions)
        getTestCardsService
            .getCards(for: subjectID, with: testID, filterBY: .allCards)
            .replaceError(with: [])
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.testsArchiveCardsFilter = .allCards
            })
            .assign(to: \.allCards, on: self)
            .store(in: &subscriptions)
    }
    
    func isCorrectCard(card: Card) -> Bool {
        return correctCards.contains(card)
    }
}
