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

final class FirebaseAddNewCardService: FirebaseDatabaseService {
    var ref = Database.database().reference().child("users")
    func addNewCard(card: Card) -> Result<Void, FirebaseAddNewCardServiceError> {
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                return .failure(.userIsNotAvailable)
            }
            let currentRef = self.ref.child(userID).child("subjects").child(card.subjectID).child("cards").child(card.id)
            guard let dictionary = card.getDictionary() else {
                return .failure(.encodingFormatIsNotValid)
            }
            currentRef.setValue(dictionary)
        return .success(())
    }
}
