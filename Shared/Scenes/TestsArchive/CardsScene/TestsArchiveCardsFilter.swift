//
//  File.swift
//  File
//
//  Created by Radi Barq on 06/09/2021.
//

import Foundation

enum TestsArchiveCardsFilter: String, CaseIterable, Identifiable {
    case allCards
    case correctCards
    case wrongCards
    var id: String { self.rawValue }
    var title: String {
        switch self {
        case .allCards:
            return "All cards"
        case .correctCards:
            return "Correct cards"
        case .wrongCards:
            return "Wrong cards"
        }
    }
}
