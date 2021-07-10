//
//  FilterOptions.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 01/07/2021.
//

import Foundation

enum FilterOptions: String, CaseIterable, Identifiable {
    case today      = "Today"
    case last7Days   = "Last 7 days"
    case last30Days  = "Last 30 days"
    case customDate = "Custom"
    var id: String { self.rawValue }
}
