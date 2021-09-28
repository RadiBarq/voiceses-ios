//
//  Test.swift
//  Voiceses
//
//  Created by Radi Barq on 10/08/2021.
//
import Foundation

struct Test: Identifiable, Codable {
    var id: String?
    let subjectID: String
    let allCards: [Card]
    let correctCards: [Card]?
    let wrongCards: [Card]?
    let dateCreated: String
    let timestamp: Int64
    let score: Double
}
