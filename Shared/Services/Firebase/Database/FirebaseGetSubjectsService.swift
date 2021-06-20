//
//  FirebaseGetSubjectsService.swift
//  Voiceses
//
//  Created by Radi Barq on 03/04/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetSubjectsServiceError: Error, LocalizedError {
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

class FirebaseGetSubjectsService: FirebaseDatabaseService {
    var subjects: AnyPublisher<[Subject], FirebaseGetSubjectsServiceError> {
        self.currentValueSubject.eraseToAnyPublisher()
    }
    let ref = Database.database().reference().child("users")
    private let currentValueSubject = CurrentValueSubject<[Subject], FirebaseGetSubjectsServiceError>([])
    init() {
        startListenToDataChange()
    }
    private func startListenToDataChange() {
        guard let userID = FirebaseAuthenticationService.getUserID() else {
            currentValueSubject.send(completion: .failure(.userIsNotAvailable))
            return
        }
        ref.child(userID).child("subjects").queryOrdered(byChild: "timestamp").observe(.value) { [weak self] snapshot in
            var subjects = [Subject]()
            for child in snapshot.children {
                guard let snapshot = child as? DataSnapshot, let dict = snapshot.value as? [String: Any], let subject = Subject(dictionary: dict) else {
                    self?.currentValueSubject.send(completion: .failure(.decodingFormatIsNotValid))
                    return
                }
                subjects.append(subject)
            }
            self?.currentValueSubject.send(subjects)
        }
    }
}

class Test1FirebaseGetCardsService: FirebaseDatabaseService {
    let ref: DatabaseReference = Database.database().reference().child("users")
    func getCards(for subjectID: String) -> AnyPublisher<[Card], FirebaseGetSubjectsServiceError> {
        return Future { [weak self] promise in
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            self?.ref.child(userID)
                .child("subjects")
                .child(subjectID)
                .child("cards")
                .queryOrdered(byChild: "timestamp")
                .observeSingleEvent(of: .value) { snapshot in
                    var cards = [Card]()
                    for child in snapshot.children {
                        guard let snapshot = child as? DataSnapshot,
                              let dict = snapshot.value as? [String: Any],
                              let card = Card(dictionary: dict) else {
                                  promise(.failure(.decodingFormatIsNotValid))
                                  return
                              }
                        cards.append(card)
                    }
                    promise(.success(cards))
                }
        }
        .eraseToAnyPublisher()
    }
}
