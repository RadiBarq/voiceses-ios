//
//  FirebaseGetLecturesService.swift
//  Voiceses
//
//  Created by Radi Barq on 25/04/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetLecturesServiceError: Error, LocalizedError {
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

struct GetLecturesService: FirebaseDatabaseService {
    var ref: DatabaseReference = Database.database().reference().child("users")
    func getLectures(for subjectID: String) -> AnyPublisher<[Lecture], FirebaseGetLecturesServiceError> {
        Future<[Lecture], FirebaseGetLecturesServiceError> { promise in
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            ref.child(userID).child("lectures").child(subjectID).observeSingleEvent(of: .value) { snapshot in
                guard let lectures = [String: Lecture](dictionary: snapshot.value as? [String: Any] ?? [:]) else {
                    promise(.failure(.decodingFormatIsNotValid))
                    return
                }
                promise(.success(Array(lectures.values)))
                
            }
        }
        .eraseToAnyPublisher()
    }
}
