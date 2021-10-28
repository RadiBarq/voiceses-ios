//
//  FirebaseAddNewCalendarCardService.swift
//  Voiceses
//
//  Created by Radi Barq on 11/10/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseAddNewCalendarCardServiceError: Error, LocalizedError {
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

final class FirebaseAddNewCalendarCardService: FirebaseDatabaseService {
    var ref = Database.database().reference().child("users")
    func addNew(card: Card, for date: String) -> Result<Void, FirebaseAddNewCalendarCardServiceError> {
        guard let userID = FirebaseAuthenticationService.getUserID() else {
            return .failure(.userIsNotAvailable)
        }
        let currentRef = self.ref.child(userID)
            .child("calendar-cards")
            .child("dates")
            .child(date)
            .child("cards")
            .child(card.id)
        guard let dictionary = card.getDictionary() else {
            return .failure(.encodingFormatIsNotValid)
        }
        currentRef.setValue(dictionary)
        return .success(())
    }
}
