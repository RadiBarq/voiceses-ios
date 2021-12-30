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
        guard let userID = FirebaseAuthenticationService.shared.getUserID() else { return }
        let year = Calendar.current.dateComponents([.year], from: DateFormatter.getDefaultCalanderFormatter().date(from: date)!).year
        ref.child(userID)
            .child("calendar-cards")
            .child("years")
            .child(String(year!))
            .child("cards")
            .child(id)
            .removeValue()
    }
}
