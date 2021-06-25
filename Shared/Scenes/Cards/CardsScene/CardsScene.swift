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
                        cardsViewModel.showingAddNewCardView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
                
                
            }
            .navigationTitle(cardsViewModel.title)
            .fullScreenCover(isPresented: $cardsViewModel.showingAddNewCardView) {
                AddNewCardScene(isPresented: $cardsViewModel.showingAddNewCardView, addNewCardViewModel: AddNewCardViewModel(subject: cardsViewModel.subject))
            }
#else
        content
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: "chevron.backward")
                    })
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
#endif
    }
}

struct CardsScene_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CardsViewModel(subject: testSubjects[0])
#if os(iOS)
        return CardsScene(cardsViewModel: viewModel)
#else
        return CardsScene(cardsViewModel: viewModel, isPresented: .constant(false))
#endif
    }
}
