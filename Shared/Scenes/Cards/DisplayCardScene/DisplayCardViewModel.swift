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
        _shadowColor ?? Color(hex: subject.colorHex)
    }
    var card: Card
    private var subject: Subject
    private var _shadowColor: Color?
    init(subject: Subject, card: Card, shadowColor: Color? = nil) {
        self.subject = subject
        self.card = card
        self._shadowColor = shadowColor
    }
}
