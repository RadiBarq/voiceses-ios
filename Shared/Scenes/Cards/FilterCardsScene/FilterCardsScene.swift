//
//  FilterCardsScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 30/06/2021.
//

import Foundation
import SwiftUI

struct FilterCardsScene: View {
    @Binding var isPresented: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var selectedDateFilterOption: DateFilterOption
    @Binding var filterIsApplied: Bool
    @StateObject private var filterCardsViewModel = FilterCardsViewModel()
    var body: some View {
#if os(iOS)
        NavigationView {
            content
                .toolbar(content: {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            applyFilter()
                        }, label: { Text("Apply") })
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            filterIsApplied.toggle()
                            resetFilters()
                            isPresented = false
                        }, label: { Text("Remove filter") })
                            .disabled(!filterIsApplied)
                    }
                })
                .alert(isPresented: $filterCardsViewModel.showingAlert) {
                    Alert(title: Text(alertTitle),
                          message: Text(filterCardsViewModel.alertMessage),
                          dismissButton: .default(Text(alertDismissButtonTitle))
                    )
                }
        }
        .accentColor(Color.accent)
#else
        ScrollView {
            content
                .toolbar(content: {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            applyFilter()
                        }, label: { Text("Apply") })
                    }
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            filterIsApplied.toggle()
                            resetFilters()
                            isPresented = false
                        }, label: { Text("Remove filter") })
                            .disabled(!filterIsApplied)
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        Button(action: {
                            isPresented = false
                        }, label: { Text("Close") })
                    }
                })
                .alert(isPresented: $filterCardsViewModel.showingAlert) {
                    Alert(title: Text(alertTitle),
                          message: Text(filterCardsViewModel.alertMessage),
                          dismissButton: .default(Text(alertDismissButtonTitle))
                    )
                }
                .padding()
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
                .accentColor(Color.accent)
        }
#endif
    }
    private var content: some View {
        return Form {
            Section(header: Text("Filter by")) {
                Picker("", selection: $selectedDateFilterOption) {
                    ForEach(DateFilterOption.allCases) { option in
                        Text(option.rawValue)
                            .tag(option)
                            .font(.footnote)
                    }
                }
                .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                .pickerStyle(.segmented)
                
                if  selectedDateFilterOption == .customDate {
                    VStack(alignment: .leading) {
                        DatePicker("Start date",
                                   selection: $startDate,
                                   in: ...Date.startOfYesterday,
                                   displayedComponents: [.date])
                        DatePicker("End date",
                                   selection: $endDate,
                                   in: ...Date(),
                                   displayedComponents: [.date])
                    }
                    .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                }
            }
        }
        .navigationTitle("Filter Cards")
        .animation(.default, value: selectedDateFilterOption)
    }
}

fileprivate extension FilterCardsScene {
    private func applyFilter() {
        if filterCardsViewModel.isSelectedDateValid(from: startDate, to: endDate) {
            filterIsApplied = true
            isPresented.toggle()
        } else {
            filterCardsViewModel.showInvalidSelectedDateMessage()
        }
    }
    
    private func resetFilters() {
        startDate = Date.startOfYesterday
        endDate = Date()
        selectedDateFilterOption = .today
    }
}

struct FilterCardsScene_Previews: PreviewProvider {
    static var previews: some View {
        FilterCardsScene(isPresented: .constant(true),
                         startDate: .constant(Date.startOfYesterday),
                         endDate: .constant(Date()),
                         selectedDateFilterOption: .constant(.today),
                         filterIsApplied: .constant(false))
    }
}
