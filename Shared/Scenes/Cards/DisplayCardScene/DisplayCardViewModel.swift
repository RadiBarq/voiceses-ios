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
    
    var shadowColor: Color {
        if let shadowColor = _shadowColor { return shadowColor }
        else if let subject = subject { return Color(hex: subject.colorHex) }
        else { return Color.primary }
    }
    
    var card: Card
    private var subject: Subject?
    private var _shadowColor: Color?
    init(card: Card, subject: Subject? = nil, shadowColor: Color? = nil) {
        self.subject = subject
        self.card = card
        self._shadowColor = shadowColor
    }
}
