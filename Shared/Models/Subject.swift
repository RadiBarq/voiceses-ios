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
    var numberOfLectures: Int?
    var colorHex: String
    var timestamp: Int64
}

var testSubjects = [
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfLectures: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfLectures: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfLectures: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfLectures: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfLectures: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfLectures: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfLectures: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfLectures: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfLectures: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfLectures: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfLectures: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfLectures: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfLectures: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfLectures: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfLectures: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfLectures: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfLectures: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfLectures: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfLectures: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfLectures: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfLectures: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfLectures: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfLectures: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfLectures: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfLectures: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfLectures: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfLectures: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfLectures: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfLectures: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfLectures: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Chemistry",
        numberOfLectures: 5000,
        colorHex: "#00BAFF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Physics",
        numberOfLectures: 50,
        colorHex: "#5000E5",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Biology",
        numberOfLectures: 35,
        colorHex: "#0085FF",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Mathematics",
        numberOfLectures: 5,
        colorHex: "#FF5965",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Astronomy",
        numberOfLectures: 100,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    ),
    Subject(
        id: UUID().uuidString,
        title: "Computer Science",
        numberOfLectures: 3,
        colorHex: "#8E5AF7",
        timestamp: Date.currentTimeStamp
    )
]
