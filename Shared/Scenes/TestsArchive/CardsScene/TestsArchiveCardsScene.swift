//
//  TestsArchiveCardsViewModel.swift
//  TestsArchiveCardsViewModel
//
//  Created by Radi Barq on 06/09/2021.
//

import SwiftUI

struct TestsArchiveCardsScene: View {
    let subject: Subject
    let test: Test
    
    @StateObject private var viewModel = TestsArchiveCardsViewModel()
#if !os(iOS)
    @State private var selectedCard: Card!
    @State private var displayCardScenePushed = false
#endif
    
    var body: some View {
        content
            .onAppear {
                viewModel.populateCards(for: subject.id!, with: test.id!)
            }
    }
    
    private var content: some View {
#if !os(iOS)
        return GeometryReader { geometry in
            if !displayCardScenePushed {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                        ForEach(viewModel.correctCards) { card in
                            CardView(card: .constant(card), shouldShowDeleteIcon: .constant(false)) {}
                            .shadow(color: Color(hex: subject.colorHex).opacity(0.8), radius: 20, x: 0, y: 10)
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                            .onTapGesture {
                                displayCardScenePushed.toggle()
                                selectedCard = card
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                }
                .animation(.easeInOut(duration: 0.5), value: viewModel.correctCards)
                .transition(.move(edge: .leading))
            }
            
            if displayCardScenePushed {
                DisplayCardScene(isPresented: $displayCardScenePushed, displayCardViewModel: DisplayCardViewModel(subject: subject, card: selectedCard))
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.default , value: displayCardScenePushed)
#endif
    }
}
