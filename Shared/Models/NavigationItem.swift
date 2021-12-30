//
//  NavigationItem.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

enum NavigationItem: Int, CaseIterable, Identifiable {
    case subjects
    case testsArchive
    case cardsCalendar
    case settings
    
    var id: Int {
        self.rawValue
    }
    
    var title: String {
        switch self {
        case .subjects:
            return "Subjects"
        case .testsArchive:
            return "Tests Archive"
        case .cardsCalendar:
            return "Cards Calendar"
        case .settings:
            return "Settings"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .subjects:
            return "book.closed.fill"
        case .testsArchive:
            return "archivebox.fill"
        case .cardsCalendar:
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
        case .testsArchive:
            TestsArchiveSubjectsScene()
        case .cardsCalendar:
            CalendarScene(calendar: Calendar(identifier: .gregorian))
        case .settings:
            SettingsScene()
        }
    }
}
