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
    
    func setup(cards: [Card]) {
        self.cards = cards
    }
}
