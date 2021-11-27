import SwiftUI

struct CalendarScene: View {
    @StateObject private var viewModel = CalendarViewModel()
    private let calendar: Calendar
    init(calendar: Calendar) {
        self.calendar = calendar
    }
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CalendarView(
                    calendar: calendar,
                    date: $viewModel.selectedDate,
                    datesWithCards: $viewModel.dates,
                    content: { date in
                        Button(action: { viewModel.set(selectedDate: date) }) {
                            Text("00")
                                .frame(minWidth: geometry.size.width / 9.5, minHeight: geometry.size.height / 9.5)
                                .foregroundColor(.clear)
                                .background(
                                    viewModel.areCardsAddedTo(date: date) ? Color.accent : Color.primary
                                )
                                .clipShape(RoundedRectangle(cornerRadius: geometry.size.height / 20, style: .continuous))
                                .accessibilityHidden(true)
                                .overlay(
                                    Text(viewModel.dayFormatter?.string(from: date) ?? "")
                                        .foregroundColor(.white)
                                )
                        }
                        .animation(.default, value: viewModel.selectedDate)
                    },
                    trailing: { date in
                        Text(viewModel.dayFormatter?.string(from: date) ?? "")
                            .foregroundColor(.secondary)
                    },
                    header: { date in
                        Text(viewModel.weekDayFormatter?.string(from: date) ?? "")
                            .font(.subheadline)
                    },
                    title: { date in
                        HStack {
                            Text(viewModel.monthFormatter?.string(from: date) ?? "")
                                .font(.headline)
                                .padding()
                            Spacer()
                            Button(action: {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
                                    value: -1,
                                    to: viewModel.selectedDate
                                ) else {
                                    return
                                }
                                
                                viewModel.set(selectedDate: newDate)
                            }) {
                                Label(
                                    title: { Text("Previous") },
                                    icon: { Image(systemName: "chevron.left") }
                                )
                                    .labelStyle(IconOnlyLabelStyle())
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                            .disabled(viewModel.isPreviousButtonDisabled)
                            .foregroundColor(viewModel.isPreviousButtonDisabled ? .gray : Color.accent)
                            
                            Button(action: {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
                                    value: 1,
                                    to: viewModel.selectedDate
                                ) else {
                                    return
                                }
                                viewModel.set(selectedDate: newDate)
                            }) {
                                Label(
                                    title: { Text("Next") },
                                    icon: { Image(systemName: "chevron.right") }
                                )
                                    .labelStyle(IconOnlyLabelStyle())
                                    .padding(.horizontal)
                                    .frame(maxHeight: .infinity)
                            }
                            .disabled(viewModel.isNextButtonDisabled)
                            .foregroundColor(viewModel.isNextButtonDisabled ? .gray : Color.accent)
                        }
                        .padding(.bottom, 6)
                    }
                )
                .equatable()
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .onAppear {
                viewModel.setup(with: self.calendar)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack {
                    Text("Selected year")
                    Picker("", selection: $viewModel.selectedYear) {
                        ForEach((viewModel.minYear...calendar.component(.year, from: Date.now)).reversed(), id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .onChange(of: viewModel.selectedYear) { selectedYear in
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: viewModel.selectedDate)
            component.year = selectedYear
            viewModel.set(selectedDate: Calendar.current.date(from: component) ?? viewModel.selectedDate)
        }
    }
}
