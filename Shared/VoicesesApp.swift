//
//  VoicesesApp.swift
//  Shared
//
//  Created by Radi Barq on 13/03/2021.
//

import SwiftUI
import Firebase

@main
struct VoicesesApp: App {
    init() {
        FirebaseApp.configure()
        FirebaseAuthenticationService.shared.startUpdatingUserState()
    }
    
    var body: some Scene {
        WindowGroup {
            LunchWindow()
        }
    }
}
