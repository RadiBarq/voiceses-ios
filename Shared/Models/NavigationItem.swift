//
//  NavigationItem.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

enum NavigationItem: Int, CaseIterable, Identifiable {
    case courses
    case lectures
    case search
    case calendar
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .courses:
            return "Courses"
        case .lectures:
            return "Lectures"
        case .search:
            return "Search"
        case .calendar:
            return "Calander"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .courses:
            return "book.closed"
        case .lectures:
            return "graduationcap"
        case .search:
            return "magnifyingglass"
        case .calendar:
            return "calendar"
        }
    }
    
    var view: AnyView {
        switch self {
        case .courses:
            return AnyView(CoursesScene())
        case .lectures:
            return AnyView(LecturesScene())
        case .search:
            return AnyView(SearchScene())
        case .calendar:
            return AnyView(CalanderScene())
        }
    }
}
