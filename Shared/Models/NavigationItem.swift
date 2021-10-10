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
    case calendar
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
        case .calendar:
            return "Calender"
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
        case .testsArchive:
            TestsArchiveSubjectsScene()
        case .calendar:
            CalendarScene(calendar: Calendar(identifier: .gregorian))
        case .settings:
            SettingsScene()
        }
    }
}
