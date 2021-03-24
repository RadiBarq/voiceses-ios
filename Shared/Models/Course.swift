//
//  Course.swift
//  Voiceses
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct Course: Identifiable, Hashable {
    var id: UUID
    var title: String
    var numberOfLectures: Int
    var color: Color
}

var testCourses = [
    Course(
        id: UUID(),
        title: "Chemistry",
        numberOfLectures: 5000,
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Physics",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Biology",
        numberOfLectures: 35,
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Mathematics",
        numberOfLectures: 5,
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Astronomy",
        numberOfLectures: 100,
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Computer Science",
        numberOfLectures: 3,
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Chemistry",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Physics",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Biology",
        numberOfLectures: 35,
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Mathematics",
        numberOfLectures: 5,
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Astronomy",
        numberOfLectures: 100,
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Computer Science",
        numberOfLectures: 3,
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Chemistry",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Physics",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Biology",
        numberOfLectures: 35,
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Mathematics",
        numberOfLectures: 5,
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Astronomy",
        numberOfLectures: 100,
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Computer Science",
        numberOfLectures: 3,
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Chemistry",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Physics",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Biology",
        numberOfLectures: 35,
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Mathematics",
        numberOfLectures: 5,
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Astronomy",
        numberOfLectures: 100,
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Computer Science",
        numberOfLectures: 3,
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Chemistry",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Physics",
        numberOfLectures: 50,
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Biology",
        numberOfLectures: 35,
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Mathematics",
        numberOfLectures: 5,
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Astronomy",
        numberOfLectures: 100,
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
    ),
    Course(
        id: UUID(),
        title: "Computer Science",
        numberOfLectures: 3,
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1))
    )
]
