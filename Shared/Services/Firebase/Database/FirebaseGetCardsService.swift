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

struct FirebaseGetCardsService: FirebaseDatabaseService {
    var cards: AnyPublisher<[Card], FirebaseGetCardsServiceError> {
        self.cardsValueSubject.eraseToAnyPublisher()
    }
    
    let ref: DatabaseReference = Database.database().reference().child("users")
    private let cardsValueSubject = CurrentValueSubject<[Card], FirebaseGetCardsServiceError>([])
    private let subjectID: String
    
    init(subjectID: String) {
        self.subjectID = subjectID
        startListenToDataChange()
    }
    
    private func startListenToDataChange() {
        guard let userID = FirebaseAuthenticationService.getUserID() else {
            cardsValueSubject.send(completion: .failure(.userIsNotAvailable))
            return
        }
        ref.child(userID).child("subjects").child(subjectID).child("cards").queryOrdered(byChild: "timestamp").observe(.value) { snapshot in
            var cards = [Card]()
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot, let dict = snapshot.value as? [String: Any], let card = Card(dictionary: dict) else {
                    cardsValueSubject.send(completion: .failure(.decodingFormatIsNotValid))
                    return
                }
                cards.append(card)
            }
            cardsValueSubject.send(cards)
        }
    }
}
