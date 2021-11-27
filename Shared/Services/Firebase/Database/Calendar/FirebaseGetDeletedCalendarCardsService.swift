//
//  FirebaseGetDeletedCalendarDatesService.swift
//  Voiceses
//
//  Created by Radi Barq on 27/11/2021.
//

import Firebase
import Combine
import Foundation

enum FirebaseGetDeletedCalendarCardsServiceError: Error, LocalizedError {
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

final class FirebaseGetDeletedCalendarCardsService: FirebaseDatabaseService {
    var deletedCards: AnyPublisher<Card, FirebaseGetDeletedCalendarCardsServiceError>?
    var ref = Database.database().reference().child("users")
    private let deletedCardsSubject: PassthroughSubject<Card, FirebaseGetDeletedCalendarCardsServiceError>
    
    init(year: Int) {
        self.deletedCardsSubject = PassthroughSubject<Card, FirebaseGetDeletedCalendarCardsServiceError>()
        setupDeletedCards(for: year)
    }
    
    private func setupDeletedCards(for year: Int) {
        var handle: DatabaseHandle?
        var deletedCardsRef: DatabaseReference?
        deletedCards = deletedCardsSubject
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let weakSelf = self else { return }
                guard let userID = FirebaseAuthenticationService.getUserID() else {
                    weakSelf.deletedCardsSubject.send(completion: .failure(.userIsNotAvailable))
                    return
                }
                
                deletedCardsRef = weakSelf.self.ref
                    .child(userID)
                    .child("calendar-cards")
                    .child("years")
                    .child(String(year))
                    .child("cards")
                handle = deletedCardsRef?.observe(.childRemoved) { [weak weakSelf] snapshot in
                    weakSelf?.setupCards(with: snapshot)
                }
            }, receiveCancel: {
                guard let handle = handle,
                      let cardsRef = deletedCardsRef else {
                          return
                      }
                cardsRef.removeObserver(withHandle: handle)
            })
            .eraseToAnyPublisher()
    }
    
    private func setupCards(with snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let card = Card(dictionary: dict) else {
                  deletedCardsSubject.send(completion: .failure(.decodingFormatIsNotValid))
                  return
              }
        deletedCardsSubject.send(card)
    }
}
