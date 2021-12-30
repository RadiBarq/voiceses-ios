//
//  FirebaseGetTestsCards.swift
//  FirebaseGetTestsCards
//
//  Created by Radi Barq on 06/09/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetTestCardsServiceError: Error, LocalizedError {
    case userIsNotAvailable
    case decodingFormatIsNotValid
    var errorDescription: String {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .decodingFormatIsNotValid:
            return "Something wrong happened, we are working on the issue."
        }
    }
}

final class FirebaseGetTestCardsService: FirebaseDatabaseService {
    let ref: DatabaseReference = Database.database().reference().child("users")
    func getCards(for subjectID: String, with testID: String, filterBY testsArchiveCardsFilter: TestsArchiveCardsFilter) -> AnyPublisher<[Card], FirebaseGetTestCardsServiceError> {
        return Future { [weak self] promise in
            guard let userID = FirebaseAuthenticationService.shared.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            self?.ref
                .child(userID)
                .child("subjects-tests")
                .child(subjectID)
                .child("tests")
                .child(testID)
                .child(testsArchiveCardsFilter.rawValue)
                .observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let weakSelf = self else { return }
                    let cards = weakSelf.setupCards(with: snapshot)
                    promise(.success(cards))
                }
        }
        .eraseToAnyPublisher()
    }
    
    private func setupCards(with snapshot: DataSnapshot) -> [Card] {
        var cards = [Card]()
        for child in snapshot.children {
            guard let snapshot = child as? DataSnapshot,
                  let dict = snapshot.value as? [String: Any],
                  let card = Card(dictionary: dict) else {
                      continue
                  }
            cards.append(card)
        }
        return cards
    }
}
