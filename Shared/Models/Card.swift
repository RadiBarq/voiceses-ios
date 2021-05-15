//
//  Card.swift
//  Voiceses
//
//  Created by Radi Barq on 07/05/2021.
//

import Foundation

struct Card: Identifiable, Codable {
    var id: String?
    let subjectID: String
    let backImageURL: URL
    let frontImageURL: URL
    let dateCreated: String
}
