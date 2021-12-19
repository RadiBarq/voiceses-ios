//
//  LecturesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct CardsScene: View {
    @StateObject private var cardsViewModel = CardsViewModel()
    let subject: Subject
#if !os(iOS)
    @Binding var isPresented: Bool
    @State private var currentSelectedCard: Card?
    @State private var displayCardScenePushed = false
#endif
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalClass
#endif
    @Environment(\.colorScheme) private var colorScheme
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
            .navigationTitle(subject.title)
            .fullScreenCover(isPresented: $cardsViewModel.showingAddNewCardScene) {
                NavigationView {
                    AddNewCardScene(isPresented: $cardsViewModel.showingAddNewCardScene, subject: subject)
                }
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
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle(subject.title)
#endif
    }
    
    private var content: some View {
        
#if os(iOS)
        return GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(cardsViewModel.cards) { card in
                        NavigationLink(destination: DisplayCardScene(displayCardViewModel: DisplayCardViewModel(card: card, subject: subject))) {
                            CardView(card: .constant(card), shouldShowDeleteIcon: .constant(true)) {
                                cardsViewModel.deleteCard(with: card.id, date: card.dateCreated, for: subject)
                            }
                            .shadow(color: colorScheme == .light ? Color(hex: subject.colorHex).opacity(0.6) : .clear, radius: 20, x: 0, y: 10)
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                        }
                    }
                }
                .padding(horizontalClass == .compact ? 16 : 25)
            }
            .edgesIgnoringSafeArea([.leading, .trailing])
            .animation(.easeInOut(duration: 0.5), value: cardsViewModel.cards)
            .animation(.easeInOut(duration: 0.5), value: cardsViewModel.sortOptions)
            .sheet(isPresented: $cardsViewModel.showingFilterCardsScene) {
                FilterCardsScene(isPresented: $cardsViewModel.showingFilterCardsScene, startDate: $cardsViewModel.filterStartDate, endDate: $cardsViewModel.filterEndDate, selectedDateFilterOption: $cardsViewModel.selectedDateFilterOption, filterIsApplied: $cardsViewModel.isFilterApplied)
            }
            .sheet(isPresented: $cardsViewModel.showingSetupTestScene) {
                SetupTestScene(isPresented: $cardsViewModel.showingSetupTestScene, testCards: $cardsViewModel.testCards, showingTestScene: $cardsViewModel.showingTestScene)
            }
            .fullScreenCover(isPresented: $cardsViewModel.showingTestScene) {
                TestScene(cards: $cardsViewModel.testCards, isPresented: $cardsViewModel.showingTestScene, showsTestResultScene: $cardsViewModel.showsTestResultScreen, testResult: $cardsViewModel.testResult,
                    test: $cardsViewModel.test, subjectID: subject.id!)
            }
            .sheet(isPresented: $cardsViewModel.showsTestResultScreen) {
                TestResultScene(subject: subject, test: cardsViewModel.test!, isPresented: $cardsViewModel.showsTestResultScreen, showingTestScene: $cardsViewModel.showingTestScene)
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
        .onAppear {
            cardsViewModel.startListenToGetCards(for: subject)
        }
#else
        GeometryReader { geometry in
            if !displayCardScenePushed {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                        ForEach(cardsViewModel.cards) { card in
                            CardView(card: .constant(card), shouldShowDeleteIcon: .constant(true)) {
                                cardsViewModel.deleteCard(with: card.id, for: subject)
                            }
                            .shadow(color: colorScheme == .light ? Color(hex: subject.colorHex).opacity(0.6) : .clear, radius: 20, x: 0, y: 10)
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                            .onTapGesture {
                                displayCardScenePushed = true
                                currentSelectedCard = card
                            }
                        }
                    }
                    .padding()
                }
                .animation(.easeInOut(duration: 0.5), value: cardsViewModel.cards)
                .transition(.move(edge: .leading))
            }
            if displayCardScenePushed {
                DisplayCardScene(isPresented: $displayCardScenePushed, displayCardViewModel: DisplayCardViewModel(subject: subject, card: currentSelectedCard!))
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.default, value: isPresented)
        .animation(.default, value: displayCardScenePushed)
        .sheet(isPresented: $cardsViewModel.showingFilterCardsScene) {
            FilterCardsScene(isPresented: $cardsViewModel.showingFilterCardsScene, startDate: $cardsViewModel.filterStartDate, endDate: $cardsViewModel.filterEndDate, selectedDateFilterOption: $cardsViewModel.selectedDateFilterOption, filterIsApplied: $cardsViewModel.isFilterApplied)
        }
        .sheet(isPresented: $cardsViewModel.showingSetupTestScene) {
            SetupTestScene(isPresented: $cardsViewModel.showingSetupTestScene, testCards: $cardsViewModel.testCards, showingTestScene: $cardsViewModel.showingTestScene)
        }
        .sheet(isPresented: $cardsViewModel.showingTestScene) {
            TestScene(subjectID: subject.id!,
                      cards: $cardsViewModel.testCards, isPresented: $cardsViewModel.showingTestScene, showsTestResultScene: $cardsViewModel.showsTestResultScreen,
                      testReuslt: $cardsViewModel.testResult,
                      test: $cardsViewModel.test)
        }
        .sheet(isPresented: $cardsViewModel.showsTestResultScreen) {
            TestResultScene(subject: subject, test: cardsViewModel.test!, isPresented: $cardsViewModel.showsTestResultScreen, testResult: $cardsViewModel.testResult, showingTestScene: $cardsViewModel.showingTestScene)
        }
        .onAppear {
            cardsViewModel.startListenToGetCards(for: subject)
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
