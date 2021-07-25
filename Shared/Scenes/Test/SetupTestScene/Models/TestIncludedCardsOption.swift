//
//  TestIncludedCardsOption.swift
//  Voiceses
//
//  Created by Radi Barq on 15/07/2021.
//

import Foundation
enum TestIncludedCardsOption: String, CaseIterable, Identifiable {
    case allCards = "All cards"
    case filteredCards = "Filter cards"
    var id: String { self.rawValue }
}
