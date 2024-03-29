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
    @Environment(\.colorScheme) private var colorScheme
#if !os(iOS)
    @State private var selectedCard: Card!
    @State private var displayCardScenePushed = false
#endif
    
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalClass
#endif
    var body: some View {
        content
            .onAppear {
                guard let subjectID = subject.id, let testID = test.id else {
                    viewModel.populateCards(for: test)
                    return
                }
                viewModel.populateCards(for: subjectID, with: testID)
            }
            .animation(.easeInOut(duration: 0.5), value: viewModel.cards)
            .navigationTitle(viewModel.getNavigationTitleFor(test: test))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Picker("", selection: $viewModel.testsArchiveCardsFilter) {
                        ForEach(TestsArchiveCardsFilter.allCases) { option in
                            Text(option.title)
                                .tag(option)
                                .font(.footnote)
                        }
                    }
                }
            }
    }
    
    private var content: some View {
#if os(iOS)
        return GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                Text("Score: " + String(format: "%.2f", test.score) + "%")
                    .font(.title)
                    .bold()
                    .padding()
                    .foregroundColor(.accent)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                    ForEach(viewModel.cards) { card in
                        NavigationLink(destination: DisplayCardScene(displayCardViewModel: DisplayCardViewModel(card: card, subject: subject, shadowColor: viewModel.isCorrectCard(card: card) ? Color.green.opacity(0.6) : Color.red.opacity(0.6)))) {
                            CardView(card: .constant(card), shouldShowDeleteIcon: .constant(false)) {
                            }
                            .shadow(color: colorScheme == .light ?
                                    (viewModel.isCorrectCard(card: card) ?
                                     Color.green.opacity(0.6) : Color.red.opacity(0.6)) :
                                            .clear,
                                    radius: 20, x: 0, y: 10)
                            .frame(minWidth: geometry.size.width / 2.3, minHeight: geometry.size.height / 2.3)
                            .padding()
                        }
                    }
                }
                .padding(horizontalClass == .compact ? 16 : 25)
            }
            .edgesIgnoringSafeArea([.leading, .trailing])
        }
#else
        return GeometryReader { geometry in
            if !displayCardScenePushed {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width / 2.5), spacing: 16)]) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: .constant(card), shouldShowDeleteIcon: .constant(false)) {}
                            .shadow(color: (viewModel.isCorrectCard(card: card) ? Color.green.opacity(0.6) : Color.red.opacity(0.6)), radius: 20, x: 0, y: 10)
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
