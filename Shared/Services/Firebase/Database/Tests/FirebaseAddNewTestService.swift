//
//  FirebaseAddNewTestService.swift
//  Voiceses
//
//  Created by Radi Barq on 10/08/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseAddNewTestServiceError: Error, LocalizedError {
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

final class FirebaseAddNewTestService: FirebaseDatabaseService {
    var ref = Database.database().reference().child("users")
    func addNewTest(test: Test) -> AnyPublisher<Void, FirebaseAddNewTestServiceError> {
        return Future { [weak self] promise in
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            let testID = self?.ref
                .child("subjects-tests")
                .childByAutoId()
                .key
            var test = test
            test.id = testID
            guard let dictionary = test.getDictionary() else {
                promise(.failure(.encodingFormatIsNotValid))
                return
            }
            self?.ref
                .child(userID)
                .child("subjects-tests")
                .child(test.subjectID)
                .child("tests")
                .child(testID!)
                .setValue(dictionary)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
