//
//  FirebaseDeleteASubjectService.swift
//  Voiceses
//
//  Created by Radi Barq on 17/04/2021.
//

import Foundation
import Firebase

final class FirebaseDeleteASubjectService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    func deleteSubject(with id: String) {
        guard let userID = FirebaseAuthenticationService.shared.getUserID() else { return }
        ref.child(userID).child("subjects").child(id).removeValue()
    }
}
