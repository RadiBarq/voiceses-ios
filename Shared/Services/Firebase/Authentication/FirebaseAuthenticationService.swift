//
//  AuthenticationService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Firebase
import Combine

final class FirebaseAuthenticationService {
    
    static var shared = FirebaseAuthenticationService()
    
    var isUserLoggedinPublisher: AnyPublisher<Bool?, Never> {
        isUserLoggedInSubject.eraseToAnyPublisher()
    }

    private var isUserLoggedInSubject = CurrentValueSubject<Bool?, Never>(nil)
    
    private init() {
    }

    func getUserID() -> String? {
        return Auth.auth().currentUser!.uid
    }
    
    func getUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    func logout() throws {
       try Auth.auth().signOut()
    }
    
    func startUpdatingUserState() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isUserLoggedInSubject.send(user != nil)
        }
    }
}
