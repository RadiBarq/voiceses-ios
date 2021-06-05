//
//  CardSide.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 01/06/2021.
//

import Foundation

enum CardSide: String {
    case front
    case back
    
    mutating func toggle() {
        self = self == .front ? .back : .front
    }
}
