//
//  FirebaseGetCalendarDatesService.swift
//  Voiceses
//
//  Created by Radi Barq on 04/11/2021.
//

import Firebase
import Combine

enum FirebaseGetAddedCalendarCardsServiceError: Error, LocalizedError {
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

class FirebaseGetAddedCalendarCardsService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    var cards: AnyPublisher<Card, FirebaseGetAddedCalendarCardsServiceError>?
    private let cardsSubject: PassthroughSubject<Card, FirebaseGetAddedCalendarCardsServiceError>
    
    init(year: Int) {
        self.cardsSubject = PassthroughSubject<Card, FirebaseGetAddedCalendarCardsServiceError>()
        setupCards(for: year)
    }
    
    private func setupCards(for year: Int) {
        var handle: DatabaseHandle?
        var cardsRef: DatabaseReference?
        cards = cardsSubject
            .handleEvents(receiveSubscription: { [weak self] _ in
            guard let weakSelf = self else { return }
                guard let userID = FirebaseAuthenticationService.shared.getUserID() else {
                weakSelf.cardsSubject.send(completion: .failure(.userIsNotAvailable))
                return
            }
            
            cardsRef = weakSelf.self.ref
                .child(userID)
                .child("calendar-cards")
                .child("years")
                .child(String(year))
                .child("cards")
            handle = cardsRef?.observe(.childAdded) { [weak weakSelf] snapshot in
                weakSelf?.setupCards(with: snapshot)
            }
        }, receiveCancel: {
            guard let handle = handle, let datesRef = cardsRef else {
                return
            }
            datesRef.removeObserver(withHandle: handle)
        })
            .eraseToAnyPublisher()
    }
    
    private func setupCards(with snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let card = Card(dictionary: dict) else {
                  cardsSubject.send(completion: .failure(.decodingFormatIsNotValid))
                  return
              }
        cardsSubject.send(card)
    }
}
