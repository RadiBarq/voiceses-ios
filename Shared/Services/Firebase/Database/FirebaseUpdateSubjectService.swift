//
//  FirebaseUpdateSubjectService.swift
//  Voiceses
//
//  Created by Radi Barq on 05/06/2021.
//

import Foundation
import Firebase

class FirebaseUpdateSubjectService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    func updateTitle(for subject: Subject) {
        guard let userID = FirebaseAuthenticationService.getUserID() else { return }
        ref.child(userID)
            .child("subjects")
            .child(subject.id!)
            .child("title")
            .setValue(subject.title)
    }
    
    func updateNumberOfCards(for subject: Subject) {
        guard let userID = FirebaseAuthenticationService.getUserID() else { return }
        ref.child(userID)
            .child("subjects")
            .child(subject.id!)
            .child("numberOfCards")
            .setValue(subject.numberOfCards)
    }
}
