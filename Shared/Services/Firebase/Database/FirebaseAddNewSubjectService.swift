//
//  AddNewSubjectService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Firebase
import Combine

enum FirebaseAddNewSubjectServiceErorr: Error, LocalizedError {
    case userIsNotAvailable
    
    case inputFormatIsNotValid

    var errorDescription: String {
        switch self {
        case .userIsNotAvailable:
            return "You are not signed in please try sign out and re-sign in."
        case .inputFormatIsNotValid:
            return "Something wron happened, we are working on the issue."
        }
    }
}

struct FirebaseAddNewSubjectService: FirebaseDatabaseService {
    let ref = Database.database().reference().child("users")
    private let authenticationService: FirebaseAuthenticationService
    
    init(authenticationService: FirebaseAuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func addNewSubject(subject: Subject) -> AnyPublisher<Void, FirebaseAddNewSubjectServiceErorr> {
        return Future { promise in
//            guard let user = authenticationService.getUser() else {
//                promise(.failure(.userIsNotAvailable))
//                return
//            }
            guard let dictionary = subject.getDictionary() else {
                promise(.failure(.inputFormatIsNotValid))
                return
            }
            ref.child(UUID().uuidString).childByAutoId().setValue(dictionary)
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}
