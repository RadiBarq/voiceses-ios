//
//  FirebaseDeleteSubjectImagesService.swift
//  Voiceses
//
//  Created by Radi Barq on 14/06/2021.
//

import Foundation
import Combine
import FirebaseStorage

enum FirebaseDeleteSubjectImagesServiceError: Error, LocalizedError {
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

final class FirebaseDeleteSubjectImagesService: FirebaseStorageService {
    let ref = Storage.storage().reference()
    func deleteImages(for subjectID: String) {
        guard let userID = FirebaseAuthenticationService.getUserID() else {
            return
        }
        self.ref
            .child("users")
            .child(userID)
            .child("subjects")
            .child(subjectID)
            .child("cards")
            .listAll { cards, error in
                guard error == nil else {
                    return
                }
                for card in cards.prefixes {
                    card.listAll { images, error in
                        guard error == nil else {
                            return
                        }
                        for image in images.items {
                            image.delete()
                        }
                    }
                }
            }
    }
}
