//
//  FirebaseGetDeletedSubjectsService.swift
//  Voiceses
//
//  Created by Radi Barq on 10/07/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetDeletedSubjectsServiceError: Error, LocalizedError {
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

final class FirebaseGetDeletedSubjectsService: FirebaseDatabaseService {
    var deletedSubjects: AnyPublisher<Subject, FirebaseGetDeletedSubjectsServiceError>?
    let ref = Database.database().reference().child("users")
    private let deletedSubjectsSubject: PassthroughSubject<Subject, FirebaseGetDeletedSubjectsServiceError>
    
    init() {
        self.deletedSubjectsSubject = PassthroughSubject<Subject, FirebaseGetDeletedSubjectsServiceError>()
        setupDeletedSubjects()
    }
    
    private func setupDeletedSubjects() {
        var handle: DatabaseHandle?
        var deletedSubjectsRef: DatabaseReference?
        deletedSubjects = deletedSubjectsSubject.handleEvents(receiveSubscription: { [weak self] _ in
            guard let weakSelf = self else { return }
            guard let userID = FirebaseAuthenticationService.shared.getUserID() else {
                weakSelf.deletedSubjectsSubject.send(completion: .failure(.userIsNotAvailable))
                return
            }
            deletedSubjectsRef = weakSelf.ref
                .child(userID)
                .child("subjects")
            handle = deletedSubjectsRef?
                .observe(.childRemoved) { [weak weakSelf] snapshot in
                    weakSelf?.setupDeletedSubjects(with: snapshot)
                }
        }, receiveCancel: {
            guard let handle = handle, let subjectsRef = deletedSubjectsRef else {
                return
            }
            subjectsRef.removeObserver(withHandle: handle)
        })
            .eraseToAnyPublisher()
    }
    
    private func setupDeletedSubjects(with snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any], let subject = Subject(dictionary: dict) else {
            deletedSubjectsSubject.send(completion: .failure(.decodingFormatIsNotValid))
                return
        }
        deletedSubjectsSubject.send(subject)
    }
}
