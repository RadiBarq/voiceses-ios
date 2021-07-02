//
//  FirebaseGetSubjectsService.swift
//  Voiceses
//
//  Created by Radi Barq on 03/04/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseGetSubjectsServiceError: Error, LocalizedError {
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

final class FirebaseGetSubjectsService: FirebaseDatabaseService {
    var subjects: AnyPublisher<[Subject], FirebaseGetSubjectsServiceError>?
    let ref = Database.database().reference().child("users")
    private let subjectsSubject: PassthroughSubject<[Subject], FirebaseGetSubjectsServiceError>
    
    init() {
        self.subjectsSubject = PassthroughSubject<[Subject], FirebaseGetSubjectsServiceError>()
        setupSubjects()
    }
    
    private func setupSubjects() {
        var handle: DatabaseHandle?
        var subjectsRef: DatabaseReference?
        subjects = subjectsSubject.handleEvents(receiveSubscription: { [weak self] _ in
            guard let weakSelf = self else { return }
            guard let userID = FirebaseAuthenticationService.getUserID() else {
                weakSelf.subjectsSubject.send(completion: .failure(.userIsNotAvailable))
                return
            }
            subjectsRef = weakSelf.ref
                .child(userID)
                .child("subjects")
            handle = subjectsRef?
                .queryOrdered(byChild: "timestamp")
                .observe(.value) { [weak weakSelf] snapshot in
                    weakSelf?.setupSubjects(with: snapshot)
                }
        }, receiveCancel: {
            guard let handle = handle, let subjectsRef = subjectsRef else {
                return
            }
            subjectsRef.removeObserver(withHandle: handle)
        })
            .eraseToAnyPublisher()
    }
    
    private func setupSubjects(with snapshot: DataSnapshot) {
        var subjects = [Subject]() 
        for child in snapshot.children {
            guard let snapshot = child as? DataSnapshot, let dict = snapshot.value as? [String: Any], let subject = Subject(dictionary: dict) else {
                subjectsSubject.send(completion: .failure(.decodingFormatIsNotValid))
                return
            }
            subjects.append(subject)
        }
        subjectsSubject.send(subjects)
    }
}
