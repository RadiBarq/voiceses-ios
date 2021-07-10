//
//  Date+Extension.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import Foundation

extension Date {
    static var startOfToday: Date { Date().startOfToday }
    static var endOfToday: Date { Date().endOfToday }
    static var startOfYesterday: Date { Date().startOfYesterday }
    static var startOfSevenDaysAgo: Date { Date().startOfSevenDaysAgo }
    static var startOfThirtyDaysAgo: Date { Date().startOfThirtyDaysAgo }
    static var currentTimeStamp: Int64 { return Date().timestamp }
    
    func getCurrentDateAsString() -> String {
        DateFormatter.getDefaultFormatter().string(from: self)
    }
    
    var endOfToday: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    var startOfToday: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfYesterday: Date {
        let oneDayBefore = Calendar.current.date(byAdding: .day, value: -1, to: self)!
        return Calendar.current.startOfDay(for: oneDayBefore)
    }

    var startOfSevenDaysAgo: Date {
        let sevenDaysBefore = Calendar.current.date(byAdding: .day, value: -7, to: self)!
        return Calendar.current.startOfDay(for: sevenDaysBefore)
    }
    
    var startOfThirtyDaysAgo: Date {
        let thirtyDaysBefore = Calendar.current.date(byAdding: .day, value: -30, to: self)!
        return Calendar.current.startOfDay(for: thirtyDaysBefore)
    }
    
    var timestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
