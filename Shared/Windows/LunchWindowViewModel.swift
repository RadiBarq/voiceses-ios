//
//  LunchWindowViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 03/04/2021.
//

import Foundation
import SwiftUI
import Combine

final class LunchWindowViewModel: ObservableObject {
    @Published var isUserLoggedin = true
    private var subscriptions = Set<AnyCancellable>()
    private var authenticationService: FirebaseAuthenticationService = FirebaseAuthenticationService()
    
    init() {
        //startListenToAuthenticationService()
    }
    
    private func startListenToAuthenticationService() {
       authenticationService
            .isUserLoggedinPublisher
            .assign(to: \.isUserLoggedin, on: self)
            .store(in: &subscriptions)
    }
}
