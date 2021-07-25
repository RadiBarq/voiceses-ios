//
//  ShowingSetupTestScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 15/07/2021.
//

import SwiftUI

struct SetupTestScene: View {
    @Binding var isPresented: Bool
    @Binding var cards: [Card]
    @StateObject private var setupTestViewModel = SetupTestViewModel()
    var body: some View {
#if os(iOS)
        NavigationView {
            content
                .navigationTitle("Setup your test")
        }
        .accentColor(Color.accent)
#else
        ScrollView {
            content
                .toolbar(content: {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Text("Start The Test")
                        })
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
                .accentColor(Color.accent)
        }
#endif
    }
    
    private var content: some View {
        return VStack {
            Form {
                Section(header: Text("Cards included")) {
                    Picker("", selection: $setupTestViewModel.selectedTestIncludedCards) {
                        ForEach(TestIncludedCardsOption.allCases) { option in
                            Text(option.rawValue)
                                .tag(option)
                                .font(.footnote)
                        }
                    }
                    .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .pickerStyle(.segmented)
                }
                if setupTestViewModel.selectedTestIncludedCards == .filteredCards {
                    Section(header: Text("Fitler cards by")) {
                        Picker("", selection: $setupTestViewModel.selectedDateFitlerOption) {
                            ForEach(DateFilterOption.allCases) { option in
                                Text(option.rawValue)
                                    .tag(option)
                                    .font(.footnote)
                            }
                        }
                        .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        .pickerStyle(.segmented)
                        if setupTestViewModel.selectedDateFitlerOption == .customDate {
                            VStack(alignment: .leading) {
                                DatePicker("Start date",
                                           selection: $setupTestViewModel.includedCardsStartDate,
                                           in: ...Date.startOfYesterday,
                                           displayedComponents: [.date])
                                DatePicker("End date",
                                           selection: $setupTestViewModel.includedCardsEndDate,
                                           in: ...Date(),
                                           displayedComponents: [.date])
                            }
                            .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                }
                Section(header: Text("Cards Order")) {
                    Picker("", selection: $setupTestViewModel.selectedTestCardsOrderOption) {
                        ForEach(TestCardsOrderOption.allCases) { option in
                            Text(option.rawValue)
                                .tag(option)
                                .font(.footnote)
                        }
                    }
                    .padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .pickerStyle(.segmented)
                }
#if os(iOS)
                Section {
                    HStack(alignment: .center) {
                        Spacer()
                        Button("Start The Test") {
                            isPresented = false
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .foregroundColor(Color.accent)
                        Spacer()
                    }
                }
#endif
            }
            Spacer()
            HStack {
                Text("Smart order: The app learns from your previous mistakes and shows you the cards you answered wrong more frequently.")
                    .font(.footnote)
                Spacer()
            }
            .padding()
        }
    }
}

struct ShowingSetupTestScene_Previews: PreviewProvider {
    static var previews: some View {
        SetupTestScene(isPresented: .constant(false), cards: .constant([]))
    }
}
