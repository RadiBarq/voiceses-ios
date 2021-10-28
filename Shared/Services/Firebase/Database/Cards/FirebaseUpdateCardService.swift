//
//  UpdateCardTestScore.swift
//  UpdateCardTestScore
//
//  Created by Radi Barq on 29/08/2021.
//

import Foundation
import Firebase

final class FirebaseUpdateCardService: FirebaseDatabaseService {
    var ref = Database.database().reference().child("users")
    func updateTestScore(for card: Card) {
        guard let userID = FirebaseAuthenticationService.getUserID() else { return }
        ref.child(userID)
            .child("subjects-cards")
            .child(card.subjectID)
            .child("cards")
            .child(card.id)
            .child("testScore")
            .setValue(card.testScore)
    }
}
