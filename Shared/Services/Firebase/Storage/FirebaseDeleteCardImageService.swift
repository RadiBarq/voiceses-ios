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
    case deletionFailed(error: Error)
    var errorDescription: String? {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .deletionFailed(let error):
            return error.localizedDescription
        }
    }
}

final class FirebaseDeleteCardImageService: FirebaseStorageService {
    let ref = Storage.storage().reference()
    func deleteImage(with id: String, cardID: String, subjectID: String) -> AnyPublisher<Void, FirebaseDeleteACardServiceError> {
        return Future { [weak self] promise in
            guard let weakSelf = self else { return }
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                promise(.failure(.userIsNotAvailable))
                return
            }
            weakSelf.ref
                .child("users")
                .child(userID)
                .child("subjects")
                .child(subjectID)
                .child("cards")
                .child(cardID)
                .child(id)
                .delete() { error in
                    guard error == nil else {
                        promise(.failure(.deletionFailed(error: error!)))
                        return
                    }
                    promise(.success(()))
                }
        }
        .eraseToAnyPublisher()
    }
}
