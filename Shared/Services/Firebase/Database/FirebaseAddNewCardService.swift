//
//  AddNewCardService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 07/05/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseAddNewCardServiceError: Error, LocalizedError {
    case userIsNotAvailable
    case encodingFormatIsNotValid
    var errorDescription: String {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .encodingFormatIsNotValid:
            return "Something wrong happened, we are working on the issue."
        }
    }
}

class FirebaseAddNewCardService: FirebaseDatabaseService {
    var ref = Database.database().reference().child("users")
    func addNewCard(card: Card) -> AnyPublisher<Void, FirebaseAddNewCardServiceError> {
        return Future { [weak self] promise in
            guard let weakSelf = self else { return }
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            weakSelf.ref = weakSelf.ref.child(userID).child("subjects").child(card.subjectID).child("cards").childByAutoId()
            let cardID = weakSelf.ref.key
            var card = card
            card.id = cardID
            guard let dictionary = card.getDictionary() else {
                promise(.failure(.encodingFormatIsNotValid))
                return
            }
            weakSelf.ref.setValue(dictionary)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
