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
            guard let userID = FirebaseAuthenticationService.shared.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            self?.ref
                .child(userID)
                .child("subjects-tests")
                .child(subjectID)
                .child("tests")
                .queryOrdered(byChild: "timestamp")
                .observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let weakSelf = self else { return }
                    let tests = weakSelf.setupTests(with: snapshot)
                    promise(.success(tests))
                }
        }
        .eraseToAnyPublisher()
    }
    
    private func setupTests(with snapshot: DataSnapshot) -> [Test] {
        var tests = [Test]()
        for child in snapshot.children {
            guard let snapshot = child as? DataSnapshot,
                  let dict = snapshot.value as? [String: Any],
                  let test = Test(dictionary: dict) else {
                      continue
                  }
            tests.append(test)
        }
        return tests
    }
}
