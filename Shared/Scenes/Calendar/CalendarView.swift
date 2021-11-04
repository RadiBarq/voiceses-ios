//
//  CalendarView.swift
//  Voiceses
//
//  Created by Radi Barq on 28/10/2021.
//

import SwiftUI

public struct CalendarView<Day: View, Header: View, Title: View, Trailing: View>: View {
    @Binding private var date: Date
    private var calendar: Calendar
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    private let daysInWeek = 7
    
    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title) {
            self.calendar = calendar
            self._date = date
            self.content = content
            self.trailing = trailing
            self.header = header
            self.title = title
        }
    
    public var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        return GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 7.5), spacing: 0)]) {
                    Section(header: title(month)) {
                        ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                        ForEach(days, id: \.self) { date in
                            if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                                content(date)
                            } else {
                                trailing(date)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension CalendarView: Equatable {
    public static func == (lhs: CalendarView<Day, Header, Title, Trailing>, rhs: CalendarView<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

private extension CalendarView {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            
            dates.append(date)
        }
        
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
               matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}
