//
//  FirebaseDeleteCalendarCardService.swift
//  Voiceses
//
//  Created by Radi Barq on 11/10/2021.
//

import Foundation
import Firebase

final class FirebaseDeleteCalendarCardService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    func deleteCard(with id: String, for date: String) {
        guard let userID = FirebaseAuthenticationService.getUserID() else { return }
        ref.child(userID)
            .child("calendar-cards")
            .child("dates")
            .child(date)
            .child("cards")
            .child(id)
            .removeValue()
    }
}
