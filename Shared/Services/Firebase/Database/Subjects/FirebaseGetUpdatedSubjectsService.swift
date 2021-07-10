//
//  FirebaseGetUpdatedSubjectsService.swift
//  Voiceses
//
//  Created by Radi Barq on 10/07/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetUpdatedSubjectsServiceError: Error, LocalizedError {
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

final class FirebaseGetUpdatedSubjectsService: FirebaseDatabaseService {
    var updatedSubjects: AnyPublisher<Subject, FirebaseGetUpdatedSubjectsServiceError>?
    let ref = Database.database().reference().child("users")
    private let updatedSubjectsSubject: PassthroughSubject<Subject, FirebaseGetUpdatedSubjectsServiceError>
    
    init() {
        self.updatedSubjectsSubject = PassthroughSubject<Subject, FirebaseGetUpdatedSubjectsServiceError>()
        setupUpdatedSubjects()
    }
    
    private func setupUpdatedSubjects() {
        var handle: DatabaseHandle?
        var updatedSubjectsRef: DatabaseReference?
        updatedSubjects = updatedSubjectsSubject
            .handleEvents(receiveSubscription: { [weak self] _ in
                guard let weakSelf = self else { return }
                guard let userID = FirebaseAuthenticationService.getUserID() else {
                    weakSelf.updatedSubjectsSubject.send(completion: .failure(.userIsNotAvailable))
                    return
                }
                updatedSubjectsRef = weakSelf.ref
                    .child(userID)
                    .child("subjects")
                handle = updatedSubjectsRef?
                    .observe(.childChanged) { [weak weakSelf] snapshot in
                        weakSelf?.setupUpdatedSubjects(with: snapshot)
                    }
            }, receiveCancel: {
                guard let handle = handle, let subjectsRef = updatedSubjectsRef else {
                    return
                }
                subjectsRef.removeObserver(withHandle: handle)
            })
            .eraseToAnyPublisher()
    }
    
    private func setupUpdatedSubjects(with snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any], let subject = Subject(dictionary: dict) else {
            updatedSubjectsSubject.send(completion: .failure(.decodingFormatIsNotValid))
            return
        }
        updatedSubjectsSubject.send(subject)
    }
}
