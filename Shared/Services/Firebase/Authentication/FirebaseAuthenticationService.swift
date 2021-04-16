//
//  AuthenticationService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Firebase
import Combine

struct FirebaseAuthenticationService {
    var isUserLoggedinPublisher: AnyPublisher<Bool, Never> {
        isUserLoggedInSubject.eraseToAnyPublisher()
    }
    
    private var isUserLoggedInSubject = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        startUserStateListener()
    }

    static func getUserID() -> String? {
        //return Auth.auth().currentUser!.uid
       return "7tWnL6JKhAUn4QtuwcNeSrXfiAn2"
    }
    
    private func startUserStateListener() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            isUserLoggedInSubject.send(user != nil)
        }
    }
}