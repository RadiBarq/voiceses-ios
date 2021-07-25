//
//  TestCardsOrder.swift
//  Voiceses
//
//  Created by Radi Barq on 15/07/2021.
//

import Foundation

enum TestCardsOrderOption: String, CaseIterable, Identifiable {
    case smartOrder = "Smart order"
    case randomOrder = "Random order"
    var id: String { self.rawValue }
}
