//
//  LecturesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct CardsScene: View {
    @ObservedObject var cardsViewModel: CardsViewModel
#if !os(iOS)
    @Binding var isPresented: Bool
    @State private var currentSelectedCard: Card?
    @State private var displayCardScenePushed: Bool = false
#endif
    
    var body: some View {
#if os(iOS)
        content
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        cardsViewModel.showingAddNewCardScene.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        cardsViewModel.testCards = cardsViewModel.allCards
                        cardsViewModel.showingSetupTestScene.toggle()
                    }, label: {
                        Text("Start Test")
                    })
                        .disabled(cardsViewModel.allCards.isEmpty)
                }
            }
            .navigationTitle(cardsViewModel.title)
            .fullScreenCover(isPresented: $cardsViewModel.showingAddNewCardScene) {
                AddNewCardScene(isPresented: $cardsViewModel.showingAddNewCardScene, addNewCardViewModel: AddNewCardViewModel(subject: cardsViewModel.subject))
            }
#else
        content
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    if !displayCardScenePushed {
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Image(systemName: "chevron.backward")
                        })
                            .disabled(cardsViewModel.allCards.isEmpty)
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(cardsViewModel.title)
#endif
    }
    
    private var content: some View {
#if os(iOS)
        return GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(cardsViewModel.cards) { card in
                        NavigationLink(destination: DisplayCardScene(displayCardViewModel: DisplayCardViewModel(subject: cardsViewModel.subject, card: card))) {
                            CardView(card: .constant(card)) {
                                cardsViewModel.deleteCard(with: card.id)
                            }
                            .shadow(color: Color(hex: cardsViewModel.subject.colorHex).opacity(0.8), radius: 20, x: 0, y: 10)
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                        }
                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.5))
            }
            .sheet(isPresented: $cardsViewModel.showingFilterCardsScene) {
                FilterCardsScene(isPresented: $cardsViewModel.showingFilterCardsScene, startDate: $cardsViewModel.filterStartDate, endDate: $cardsViewModel.filterEndDate, selectedDateFilterOption: $cardsViewModel.selectedDateFilterOption, filterIsApplied: $cardsViewModel.isFilterApplied)
            }
            .sheet(isPresented: $cardsViewModel.showingSetupTestScene) {
                SetupTestScene(isPresented: $cardsViewModel.showingSetupTestScene, testCards: $cardsViewModel.testCards, showingTestScene: $cardsViewModel.showingTestScene)
            }
            .fullScreenCover(isPresented: $cardsViewModel.showingTestScene) {
                TestScene(subjectID: cardsViewModel.subject.id!, testCards: $cardsViewModel.testCards, isPresented: $cardsViewModel.showingTestScene)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        cardsViewModel.showingFilterCardsScene.toggle()
                    }, label: {
                        Text("Filter")
                    })
                        .disabled(cardsViewModel.allCards.isEmpty)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        cardsViewModel.reverseCards()
                    }, label: {
                        Image(systemName: self.cardsViewModel.sortOptions == .ascend ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                    })
                        .disabled(cardsViewModel.allCards.isEmpty)
                }
            }
        }
#else
        GeometryReader { geometry in
            if !displayCardScenePushed {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                        ForEach(cardsViewModel.cards) { card in
                            CardView(card: .constant(card)) {
                                cardsViewModel.deleteCard(with: card.id)
                            }
                            .shadow(color: Color(hex: cardsViewModel.subject.colorHex).opacity(0.8), radius: 20, x: 0, y: 10)
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                            .onTapGesture {
                                displayCardScenePushed = true
                                currentSelectedCard = card
                            }
                            .animation(.easeInOut(duration: 0.5))
                        }
                    }
                    .padding()
                }
                .transition(.move(edge: .leading)).animation(.default)
            }
            if displayCardScenePushed {
                DisplayCardScene(isPresented: $displayCardScenePushed, displayCardViewModel: DisplayCardViewModel(subject: cardsViewModel.subject, card: currentSelectedCard!))
                    .transition(.move(edge: .trailing))
                    .animation(.default)
            }
        }
        .sheet(isPresented: $cardsViewModel.showingFilterCardsScene) {
            FilterCardsScene(isPresented: $cardsViewModel.showingFilterCardsScene, startDate: $cardsViewModel.filterStartDate, endDate: $cardsViewModel.filterEndDate, selectedDateFilterOption: $cardsViewModel.selectedDateFilterOption, filterIsApplied: $cardsViewModel.isFilterApplied)
        }
        .sheet(isPresented: $cardsViewModel.showingSetupTestScene) {
            SetupTestScene(isPresented: $cardsViewModel.showingSetupTestScene, testCards: $cardsViewModel.testCards, showingTestScene: $cardsViewModel.showingTestScene)
        }
        .sheet(isPresented: $cardsViewModel.showingTestScene) {
            TestScene(subjectID: cardsViewModel.subject.id!, testCards: $cardsViewModel.testCards, isPresented: $cardsViewModel.showingTestScene)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                if !displayCardScenePushed {
                    Button(action: {
                        cardsViewModel.showingFilterCardsScene.toggle()
                    }, label: {
                        Text("Filter")
                    })
                        .disabled(cardsViewModel.allCards.isEmpty)
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .automatic) {
                if !displayCardScenePushed {
                    Button(action: {
                        cardsViewModel.reverseCards()
                    }, label: {
                        Image(systemName: cardsViewModel.sortOptions == .ascend ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                    })
                        .disabled(cardsViewModel.allCards.isEmpty)
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                if !displayCardScenePushed {
                    Button(action: {
                        cardsViewModel.testCards = cardsViewModel.allCards
                        cardsViewModel.showingSetupTestScene.toggle()
                    }, label: {
                        Text("Start Test")
                    })
                        .disabled(cardsViewModel.allCards.isEmpty)
                } else {
                    EmptyView()
                }
            }
        }
#endif
    }
}
