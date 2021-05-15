//
//  LecturesScene.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 20/03/2021.
//

import SwiftUI

struct CardsScene: View {
    @ObservedObject var cardsSceneViewModel: CardsSceneViewModel
    var body: some View {
        #if os(iOS)
        content
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        cardsSceneViewModel.showingAddNewCardView.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
            .navigationTitle(cardsSceneViewModel.title)
            .fullScreenCover(isPresented: $cardsSceneViewModel.showingAddNewCardView) {
                AddNewCardScene(isPresented: $cardsSceneViewModel.showingAddNewCardView, addNewCardViewModel: AddNewCardViewModel(subject: cardsSceneViewModel.subject))
            }
        #else
        content
        #endif
    }
    
    private var content: some View {
        #if os(iOS)
        return GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(cardsSceneViewModel.cards) { card in
                        CardView(card: card) {
                            cardsSceneViewModel.deleteCard(with: card.id)
                        }
                        .shadow(color: Color(hex: cardsSceneViewModel.subject.colorHex).opacity(0.8), radius: 20, x: 0, y: 10)
                        .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                        .padding()
                    }
                    //                    ForEach(cardsSceneViewModel.cards) { item in
                    //                        NavigationLink(destination: CardsScene(cardsSceneViewModel: CardsSceneViewModel(subject: item))
                    //                        ) {
                    //                            SubjectView(subject: item, deleteAction: {
                    //                                subjectsSceneViewModel.showDeleteSubjectAlert.toggle()
                    //                                subjectsSceneViewModel.selectedSubjectToBeDelete = item.id!
                    //                            })
                    //                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                    //                            .padding()
                    //                        }
                    //                    }
                }
                .padding()
                .animation(.easeInOut(duration: 0.5))
            }
        }
        #else
        return
            GeometryReader { geometry in
                ScrollView {
                    SearchBar(placeholder: "Search subjects...", text: $subjectsSceneViewModel.searchText)
                        .padding()
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 3), spacing: 16)]) {
                        ForEach(subjectsSceneViewModel.searchedSubjects) { item in
                            SubjectView(subject: item, deleteAction: {
                                subjectsSceneViewModel.showDeleteSubjectAlert.toggle()
                                subjectsSceneViewModel.selectedSubjectToBeDelete = item.id!
                            })
                            .frame(minWidth: geometry.size.width / 3, minHeight: geometry.size.height / 3)
                            .padding()
                            .onTapGesture {
                                subjectsSceneViewModel.showLecturesOnMac.toggle()
                            }
                            .sheet(isPresented: $subjectsSceneViewModel.showLecturesOnMac) {
                               CardsScene(cardsSceneViewModel: CardsSceneViewModel(subject: item))
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.5))
                    .padding()
                }
            }
        #endif
    }
}

struct CardsScene_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CardsSceneViewModel(subject: testSubjects[0])
        CardsScene(cardsSceneViewModel: viewModel)
    }
}
