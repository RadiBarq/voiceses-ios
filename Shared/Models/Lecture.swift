//
//  Lecture.swift
//  Voiceses
//
//  Created by Radi Barq on 21/04/2021.
//
import Foundation

struct Lecture: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var dateCreated: String
    var duration: String
}
