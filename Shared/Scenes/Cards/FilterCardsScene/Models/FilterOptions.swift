//
//  FilterOptions.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 01/07/2021.
//

import Foundation

enum FilterOptions: String, CaseIterable, Identifiable {
    case today      = "Today"
    case lastWeek   = "Last week"
    case lastMonth  = "Last month"
    case customDate = "Custom"
    var id: String { self.rawValue }
}
