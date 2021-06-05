//
//  Course.swift
//  Voiceses
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct Subject: Identifiable, Codable, Hashable {
    var id: String?
    var title: String
    var numberOfCards: Int?
    var colorHex: String
    var timestamp: Int64
}

var testSubjects = [
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfCards: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfCards: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfCards: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfCards: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfCards: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfCards: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfCards: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfCards: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfCards: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfCards: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfCards: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfCards: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfCards: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfCards: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfCards: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfCards: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfCards: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfCards: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfCards: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfCards: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfCards: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfCards: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfCards: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfCards: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfCards: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfCards: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfCards: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfCards: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfCards: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfCards: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfCards: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfCards: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfCards: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfCards: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfCards: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfCards: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    )
]
