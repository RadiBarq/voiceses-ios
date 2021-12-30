//
//  FirebaseDeleteATestForASubject.swift
//  FirebaseDeleteATestForASubject
//
//  Created by Radi Barq on 02/09/2021.
//

import Foundation
import Firebase

final class FirebaseDeleteATestForASubjectService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    func delete(at testID: String, for subjectID: String) {
        guard let userID = FirebaseAuthenticationService.shared.getUserID() else { return }
        ref.child(userID)
            .child("subjects-tests")
            .child(subjectID)
            .child("tests")
            .child(testID)
            .removeValue()
    }
}
