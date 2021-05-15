//
//  AddNewCardImageFirebaseService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 07/05/2021.
//

import FirebaseStorage
import Foundation
import Firebase
import Combine

enum FirebaseAddNewCardImageFirebaseServiceError: Error, LocalizedError {
    case userIsNotAvailable
    case downloadURLNotAvailable
    case uploadError
    
    var errorDescription: String {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .downloadURLNotAvailable, .uploadError:
            return "Something wrong happened, we are working on the issue."
        }
    }
}

class FirebaseAddNewCardImageFirebaseService: FirebaseStorageService {
    var ref = Storage.storage().reference()
    func uploadImage(with data: Data, subjectID: String, cardID: String, imageName: String) -> AnyPublisher<(URL, String), FirebaseAddNewCardImageFirebaseServiceError> {
            return Future<(URL, String), FirebaseAddNewCardImageFirebaseServiceError> { [weak self] promise in
                guard let weakSelf = self else { return }
                guard let userID = FirebaseAuthenticationService.getUserID() else {
                    promise(.failure(.userIsNotAvailable))
                    return
                }
                let currentRef = weakSelf.ref.child("users").child(userID).child("subjects").child(subjectID)
                        .child("cards")
                        .child(cardID)
                        .child("\(imageName).png")
                    currentRef.putData(data, metadata: nil) { (metadata, error) in
                        guard error == nil else {
                            promise(.failure(.uploadError))
                            return
                        }
                        currentRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                promise(.failure(.downloadURLNotAvailable))
                                return
                            }
                            promise(.success((downloadURL, cardID)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
