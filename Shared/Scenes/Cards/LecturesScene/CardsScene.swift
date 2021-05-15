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
        return GeometryReader { geometery in
            
        }
    }
}

struct CardsScene_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CardsSceneViewModel(subject: testSubjects[0])
        CardsScene(cardsSceneViewModel: viewModel)
    }
}
