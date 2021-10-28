import SwiftUI

struct CalendarScene: View {
    @State private var selectedDate = Self.now
    @State private var selectedYear: Int?
    private let calendar: Calendar
    private let monthFormatter: DateFormatter
    private let dayFormatter: DateFormatter
    private let weekDayFormatter: DateFormatter
    private let defaultFormatter: DateFormatter
    private static var now = Date()
    
    init(calendar: Calendar) {
        self.calendar = calendar
        self.monthFormatter = DateFormatter.getMonthFormatter(for: calendar)
        self.dayFormatter = DateFormatter.getDayFormatter(for: calendar)
        self.weekDayFormatter = DateFormatter.getWeekDayFormatter(for: calendar)
        self.defaultFormatter = DateFormatter.getDefaultFormatter()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CalendarView(
                    calendar: calendar,
                    date: $selectedDate,
                    content: { date in
                        Button(action: { selectedDate = date }) {
                            Text("00")
                                .frame(minWidth: geometry.size.width / 9, minHeight: geometry.size.height / 9)
                                .foregroundColor(.clear)
                                .background(
                                    calendar.isDate(date, inSameDayAs: selectedDate) ? Color.accent
                                    : calendar.isDateInToday(date) ? .green
                                    : Color.primary
                                )
                                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 20, style: .continuous))
                                .accessibilityHidden(true)
                                .overlay(
                                    Text(dayFormatter.string(from: date))
                                        .foregroundColor(.white)
                                )
                        }
                        .animation(.default, value: selectedDate)
                    },
                    trailing: { date in
                        Text(dayFormatter.string(from: date))
                            .foregroundColor(.secondary)
                    },
                    header: { date in
                        Text(weekDayFormatter.string(from: date))
                    },
                    title: { date in
                        HStack {
                            Text(defaultFormatter.string(from: date))
                                .font(.headline)
                                .padding()
                            Spacer()
                            Button {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
                                    value: -1,
                                    to: selectedDate
                                ) else {
                                    return
                                }
                                selectedDate = newDate
                            } label: {
                                Label(
                                    title: { Text("Previous") },
                                    icon: { Image(systemName: "chevron.left") }
                                )
                                    .labelStyle(IconOnlyLabelStyle())
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                            .foregroundColor(Color.accent)
                            Button {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
                                    value: 1,
                                    to: selectedDate
                                ) else {
                                    return
                                }
                                selectedDate = newDate
                            } label: {
                                Label(
                                    title: { Text("Next") },
                                    icon: { Image(systemName: "chevron.right") }
                                )
                                    .labelStyle(IconOnlyLabelStyle())
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .padding(.bottom, 6)
                    }
                )
                    .equatable()
            }
            .padding(.leading, 16)
            .padding(.trailing, 16)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack {
                    Text("Selected year")
                    Picker("", selection: $selectedYear) {
                        ForEach(2021...calendar.component(.year, from: Self.now), id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedYear) { selectedYear in
                        var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedDate)
                        component.year = selectedYear
                        selectedDate = Calendar.current.date(from: component) ?? selectedDate
                    }
                }
            }
        }
        .onAppear {
            selectedYear = calendar.component(.year, from: Self.now)
        }
    }
}

// MARK: - Component

public struct CalendarView<Day: View, Header: View, Title: View, Trailing: View>: View {
    // Injected dependencies
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let trailing: (Date) -> Trailing
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    
    // Constants
    private let daysInWeek = 7
    
    public init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder trailing: @escaping (Date) -> Trailing,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title
    ) {
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
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 7), spacing: 0)]) {
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

// MARK: - Conformances

extension CalendarView: Equatable {
    public static func == (lhs: CalendarView<Day, Header, Title, Trailing>, rhs: CalendarView<Day, Header, Title, Trailing>) -> Bool {
        lhs.calendar == rhs.calendar && lhs.date == rhs.date
    }
}

// MARK: - Helpers

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
