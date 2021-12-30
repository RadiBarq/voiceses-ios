//
//  AddNewSubjectService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseAddNewSubjectServiceError: Error, LocalizedError {
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

class FirebaseAddNewSubjectService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    func addNewSubject(subject: Subject) -> AnyPublisher<Void, FirebaseAddNewSubjectServiceError> {
        return Future { [weak self] promise in
            guard let userID = FirebaseAuthenticationService.shared.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            let subjectID = self?.ref
                .child("subjects")
                .childByAutoId()
                .key
            var subject = subject
            subject.id = subjectID
        
            guard let dictionary = subject.getDictionary() else {
                promise(.failure(.encodingFormatIsNotValid))
                return
            }
            self?.ref
                .child(userID)
                .child("subjects")
                .child(subjectID!)
                .setValue(dictionary)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
