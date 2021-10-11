//
//  DateFormatter+Extension.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import Foundation

extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
    }
    
    static func getDefaultFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    static func getDefaultFormatterWithTime() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
    
    static func getMonthFormatter(for calendar: Calendar) -> DateFormatter {
        return DateFormatter(dateFormat: "MMMM", calendar: calendar)
    }
    
    static func getDayFormatter(for calendar: Calendar) -> DateFormatter {
        return DateFormatter(dateFormat: "d", calendar: calendar)
    }
    
    static func getWeekDayFormatter(for calendar: Calendar) -> DateFormatter {
        DateFormatter(dateFormat: "EEEEE", calendar: calendar)
    }
}
