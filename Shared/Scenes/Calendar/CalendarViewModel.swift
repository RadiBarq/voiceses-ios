//
//  CalendarSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 28/10/2021.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var selectedDate = Date.now {
        didSet {
            selectedYear = calendar!.component(.year, from: selectedDate)
            guard let prevMonthDate = calendar!.date(
                byAdding: .month,
                value: -1,
                to: selectedDate), let nextMonthDate = calendar!.date(
                    byAdding: .month,
                    value: 1,
                    to: selectedDate)
            else { return }
            isNextButtonDisabled = calendar!.component(.year, from: nextMonthDate) > calendar!.component(.year, from: Date.now)
            isPreviousButtonDisabled = calendar!.component(.year, from: prevMonthDate) < minYear
        }
    }
    
    @Published var selectedYear: Int = 2021
    @Published var isNextButtonDisabled: Bool = false
    @Published var isPreviousButtonDisabled: Bool = false
    @Published var title: String = ""
    
    private(set) var calendar: Calendar?
    private(set) var monthFormatter: DateFormatter?
    private(set) var dayFormatter: DateFormatter?
    private(set) var weekDayFormatter: DateFormatter?
    private(set) var defaultFormatter: DateFormatter?
    let minYear = 2020
    func setup(with calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter.getMonthFormatter(for: calendar)
        self.dayFormatter = DateFormatter.getDayFormatter(for: calendar)
        self.weekDayFormatter = DateFormatter.getWeekDayFormatter(for: calendar)
        self.defaultFormatter = DateFormatter.getDefaultFormatter()
        self.selectedYear = calendar.component(.year, from: Date.now)
    }

    func set(selectedDate: Date) {
        self.selectedDate = selectedDate
    }
}
