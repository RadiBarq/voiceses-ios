//
//  FirebaseDeleteCardService.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import Foundation
import Firebase

final class FirebaseDeleteACardService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    func deleteCard(with id: String, subjectID: String) {
        guard let userID = FirebaseAuthenticationService.shared.getUserID() else { return }
        ref.child(userID)
            .child("subjects-cards")
            .child(subjectID)
            .child("cards")
            .child(id)
            .removeValue()
    }
}
