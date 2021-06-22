//
//  FirebaseGetLecturesService.swift
//  Voiceses
//
//  Created by Radi Barq on 25/04/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetCardsServiceError: Error, LocalizedError {
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

class FirebaseGetCardsService: FirebaseDatabaseService {
    let ref: DatabaseReference = Database.database().reference().child("users")
    var cards: AnyPublisher<[Card], FirebaseGetCardsServiceError>?
    private let subjectID: String
    private var cardsSubject: PassthroughSubject<[Card], FirebaseGetCardsServiceError>
    
    init(subjectID: String) {
        self.subjectID = subjectID
        self.cardsSubject = PassthroughSubject<[Card], FirebaseGetCardsServiceError>()
        self.setupSubjects()
    }
    
    private func setupSubjects() {
        var handle: DatabaseHandle?
        var cardsRef: DatabaseReference?
        cards = cardsSubject.handleEvents(receiveSubscription: { [weak self] _ in
            guard let weakSelf = self else { return }
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                weakSelf.cardsSubject.send(completion: .failure(.userIsNotAvailable))
                return
            }
            cardsRef = weakSelf.ref
                .child(userID)
                .child("subjects")
                .child(weakSelf.subjectID)
                .child("cards")
            handle =
            cardsRef?.queryOrdered(byChild: "timestamp")
                .observe(.value) { [weak weakSelf] snapshot in
                    weakSelf?.setupCards(with: snapshot)
                }
        }, receiveCancel: {
            guard let handle = handle, let cardsRef = cardsRef else { return }
            cardsRef.removeObserver(withHandle: handle)
        })
            .eraseToAnyPublisher()
    }
    
    private func setupCards(with snapshot: DataSnapshot) {
        var cards = [Card]()
        for child in snapshot.children {
            guard let snapshot = child as? DataSnapshot,
                  let dict = snapshot.value as? [String: Any],
                  let card = Card(dictionary: dict) else {
                      cardsSubject.send(completion: .failure(.decodingFormatIsNotValid))
                      return
                  }
            cards.append(card)
        }
        cardsSubject.send(cards)
    }
}
