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
    @Published var isUserLoggedin: Bool? = nil
    private var subscriptions = Set<AnyCancellable>()

    init() {
        startListenToAuthenticationService()
    }
    
    private func startListenToAuthenticationService() {
        FirebaseAuthenticationService.shared
            .isUserLoggedinPublisher
            .assign(to: \.isUserLoggedin, on: self)
            .store(in: &subscriptions)
    }
}
