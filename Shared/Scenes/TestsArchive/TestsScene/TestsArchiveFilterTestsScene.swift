//
//  TestsArchiveFilterTestsScene.swift
//  TestsArchiveFilterTestsScene
//
//  Created by Radi Barq on 06/09/2021.
//

import Foundation
import SwiftUI

struct TestsArchiveFilterTestsScene: View {
    @Binding var isPresented: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var isFilterApplied: Bool
    @StateObject private var viewModel = TestsArchiveFilterTestsViewModel()
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
                            isFilterApplied.toggle()
                            resetFilter()
                            isPresented.toggle()
                        }, label: { Text("Remove filter") })
                            .disabled(!isFilterApplied)
                    }
                })
                .accentColor(Color.accent)
        }
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
                            isFilterApplied.toggle()
                            resetFilter()
                            isPresented.toggle()
                        }, label: { Text("Remove filter") })
                            .disabled(!isFilterApplied)
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        Button(action: {
                            isPresented = false
                        }, label: { Text("Close") })
                    }
                })
                .accentColor(Color.accent)
                .padding()
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        }
#endif
    }
    private var content: some View {
        return Form {
            VStack(alignment: .leading) {
                DatePicker("Start date",
                           selection: $startDate,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute])
                DatePicker("End date",
                           selection: $endDate,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute])
            }
            .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text(alertDismissButtonTitle))
                )
            }
        }
    }
}

fileprivate extension TestsArchiveFilterTestsScene {
    private func applyFilter() {
        if viewModel.isSelectedDateValid(from: startDate, to: endDate) {
            isFilterApplied.toggle()
            isPresented.toggle()
        } else {
            viewModel.showInvalidSelectedDateMessage()
        }
    }
    
    private func resetFilter() {
        startDate = Date.startOfYesterday
        endDate = Date()
    }
}
