//
//  CalendarDateCardsScene.swift
//  Voiceses
//
//  Created by Radi Barq on 27/11/2021.
//

import SwiftUI

struct CalendarDateCardsScene: View {
    @StateObject private var viewModel = CalendarDateCardsViewModel()
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalClass
#endif
    
    var cards: [Card]
    var date: String
    
    var body: some View {
        return content
            .navigationTitle(date)
            .onAppear {
                viewModel.setup(cards: cards)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showingTestScene.toggle()
                    }, label: {
                        Text("Start Test")
                    })
                        .disabled(cards.isEmpty)
                }
            }
            .sheet(isPresented: $viewModel.showsTestResultScreen) {
                TestResultScene(subject: nil,
                                test: viewModel.test!,
                                isPresented: $viewModel.showsTestResultScreen,
                                showingTestScene: $viewModel.showingTestScene)
            }
            .fullScreenCover(isPresented: $viewModel.showingTestScene) {
                TestScene(cards: $viewModel.cards, isPresented: $viewModel.showingTestScene, showsTestResultScene: $viewModel.showsTestResultScreen, testResult: $viewModel.testResult, test: $viewModel.test)
            }
    }
    
    private var content: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(viewModel.cards) { card in
                        NavigationLink(destination: DisplayCardScene(displayCardViewModel: DisplayCardViewModel(card: card))) {
                            CardView(card: .constant(card),
                                     shouldShowDeleteIcon: .constant(false)) {
                            }
                                     .shadow(color: Color.primary, radius: 20, x: 0, y: 10)
                                     .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                                     .padding()
                        }
                    }
                }
                .padding(horizontalClass == .compact ? 16 : 25)
            }
            .edgesIgnoringSafeArea([.leading, .trailing])
        }
    }
}
