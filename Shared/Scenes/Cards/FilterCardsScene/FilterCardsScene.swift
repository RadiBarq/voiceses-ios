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
    @Binding var selectedFilter: FilterOptions
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
                            .disabled(false)
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
                            .disabled(false)
                        
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        Button(action: {
                            isPresented = false
                        }, label: { Text("Close") })
                    }
                })
                .accentColor(Color.accent)
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
                Picker("", selection: $selectedFilter) {
                    ForEach(FilterOptions.allCases) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
                .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                .pickerStyle(.segmented)
            }
            
            if  selectedFilter == .customDate {
                Section(header: Text("Pick custom date")) {
                    VStack(alignment: .leading) {
                        DatePicker("Start date",
                                   selection: $startDate,
                                   in: ...Date.yesterday,
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
        .animation(.default)
    }
    
    private func applyFilter() {
        if filterCardsViewModel.isSelectedDateValid(from: startDate, to: endDate) {
            isPresented.toggle()
        } else {
            filterCardsViewModel.showInvalidSelectedDateMessage()
        }
    }
}


struct FilterCardsScene_Previews: PreviewProvider {
    static var previews: some View {
        FilterCardsScene(isPresented: .constant(true),
                         startDate: .constant(Date.yesterday),
                         endDate: .constant(Date()),
                         selectedFilter: .constant(.today))
    }
}
