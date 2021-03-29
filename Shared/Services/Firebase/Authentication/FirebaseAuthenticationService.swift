//
//  AuthenticationService.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Firebase

struct FirebaseAuthenticationService {
    var isUserSignedIn: Bool  {
        return Auth.auth().currentUser != nil
    }
    
    func getUser() -> User? {
       return Auth.auth().currentUser
    }
}
