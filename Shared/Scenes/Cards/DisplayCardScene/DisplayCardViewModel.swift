//
//  ViewCardViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 16/06/2021.
//

import Foundation
import SwiftUI
import Combine

class DisplayCardViewModel: ObservableObject {
    @Published var cardSide: CardSide = .front
    var parentColor: Color {
        Color(hex: subject.colorHex)
    }
    var card: Card
    private var subject: Subject
    init(subject: Subject, card: Card) {
        self.subject = subject
        self.card = card
    }
}
