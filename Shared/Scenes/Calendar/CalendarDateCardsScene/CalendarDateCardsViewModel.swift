//
//  CalendarDateCardsViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 27/11/2021.
//

import Foundation
import SwiftUI

class CalendarDateCardsViewModel: ObservableObject {
    @Published var cards = [Card]()
    @Published var showingTestScene = false
    @Published var showsTestResultScreen = false
    @Published var test: Test?
    @Published var testResult: Double = 0.0
    
    func setup(cards: [Card]) {
        self.cards = cards
    }
}
