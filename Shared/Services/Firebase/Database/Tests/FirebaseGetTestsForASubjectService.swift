//
//  FirebaseGetTestsForASubject.swift
//  Voiceses
//
//  Created by Radi Barq on 27/08/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetTestsForASubjectServiceError: Error, LocalizedError {
    case userIsNotAvailable
    case decodingFormatIsNotValid
    var errorDescription: String {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .decodingFormatIsNotValid:
            return "Something wrong happened, we are working on the issue."
        }
    }
}


final class FirebaseGetTestsForASubjectService: FirebaseDatabaseService {
    let ref: DatabaseReference = Database.database().reference().child("users")
    func getTests(for subjectID: String) -> AnyPublisher<[Test], FirebaseGetTestsForASubjectServiceError> {
        return Future { [weak self] promise in
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            self?.ref
                .child(userID)
                .child("subject-tests")
                .child(subjectID)
                .child("tests")
                .observeSingleEvent(of: .value) { snapshot in
                    guard let dict = snapshot.value as? [String: Any], let tests = [Test](dictionary: dict) else {
                        promise(.failure(.decodingFormatIsNotValid))
                        return
                    }
                    promise(.success(tests))
                }
        }
        .eraseToAnyPublisher()
    }
}
