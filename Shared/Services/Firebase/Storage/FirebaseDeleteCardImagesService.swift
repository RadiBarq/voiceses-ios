//
//  FirebaseDeleteACardImagesService.swift
//  Voiceses
//
//  Created by Radi Barq on 14/06/2021.
//

import Foundation
import FirebaseStorage
import Combine

enum FirebaseDeleteACardServiceError: Error, LocalizedError {
    case userIsNotAvailable
    case deletetionFailed(error: Error)
    var errorDescription: String? {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .deletetionFailed(let error):
            return error.localizedDescription
        }
    }
}

class FirebaseDeleteCardImagesService: FirebaseStorageService {
    let ref = Storage.storage().reference()
    func deleteImages(with id: String, subjectID: String) -> AnyPublisher<Void, FirebaseDeleteACardServiceError> {
        return Future { [weak self] promise in
            guard let weakSelf = self else { return }
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            weakSelf.ref.child(userID)
                .child("subjects")
                .child(subjectID)
                .child(id)
                .delete() { error in
                    guard error == nil else {
                        promise(.failure(.deletetionFailed(error: error!)))
                        return
                    }
                    promise(.success(()))
                }
        }
        .eraseToAnyPublisher()
    }
}
