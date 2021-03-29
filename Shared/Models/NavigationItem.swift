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
    
    var view: AnyView {
        switch self {
        case .subjects:
            return AnyView(SubjectsScene())
        case .search:
            return AnyView(SearchScene())
        case .calendar:
            return AnyView(CalanderScene())
        case .settings:
            return AnyView(EmptyView())
        }
    }
}
