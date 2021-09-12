//
//  TestsArchiveCardsScene.swift
//  TestsArchiveCardsScene
//
//  Created by Radi Barq on 06/09/2021.
//

import Foundation
import Combine

class TestsArchiveCardsViewModel: ObservableObject {
    @Published var correctCards = [Card]()
    @Published var wrongCards = [Card]()
    private let getTestCardsService = FirebaseGetTestCardsService()
    private var subscriptions = Set<AnyCancellable>()
    func populateCards(for subjectID: String, with testID: String) {
        getTestCardsService
            .getCards(for: subjectID, with: testID, filterBY: .correct)
            .replaceError(with: [])
            .assign(to: \.correctCards, on: self)
            .store(in: &subscriptions)
        getTestCardsService
            .getCards(for: subjectID, with: testID, filterBY: .wrong)
            .replaceError(with: [])
            .assign(to: \.wrongCards, on: self)
            .store(in: &subscriptions)
    }
}
