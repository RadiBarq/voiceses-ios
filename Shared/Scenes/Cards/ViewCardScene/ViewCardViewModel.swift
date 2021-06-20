//
//  ViewCardViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 16/06/2021.
//

import Foundation
import SwiftUI
import Combine

class ViewCardViewModel: ObservableObject {
    private var subject: Subject
    private var card: Card
    
    var parentColor: Color {
        Color(hex: subject.colorHex)
    }

    init(subject: Subject, card: Card) {
        self.subject = subject
        self.card = card
    }
    
    
    
}
