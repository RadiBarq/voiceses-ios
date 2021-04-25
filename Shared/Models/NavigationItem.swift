//
//  NavigationItem.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

enum NavigationItem: Int, CaseIterable, Identifiable {
    case subjects
    case search
    case calendar
    case settings
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .subjects:
            return "Subjects"
        case .search:
            return "Search"
        case .calendar:
            return "Calander"
        case .settings:
            return "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .subjects:
            return "book.closed"
        case .search:
            return "magnifyingglass"
        case .calendar:
            return "calendar"
        case .settings:
            return "person.crop.circle"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .subjects:
            SubjectsScene()
        case .search:
            SearchScene()
        case .calendar:
            CalanderScene()
        case .settings:
           SettingsScene()
        }
    }
}
