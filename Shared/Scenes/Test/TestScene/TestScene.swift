//
//  TestScene.swift
//  Voiceses
//
//  Created by Radi Barq on 25/07/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct TestScene: View {
    @Binding var testCards: [Card]
    @Binding var isPresented: Bool
    @State var cards = test_cards
    @State var cardsSide: [String: CardSide] = ["0": .front, "1": .front, "2": .front, "3": .front, "4": .front, "5": .front]
    @StateObject private var testViewModel = TestModel()
    var body: some View {
#if os(iOS)
        NavigationView {
            content
                .accentColor(Color.accent)
                .navigationTitle("3 out of 4")
        }
#else
        ScrollView {
            content
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 600, maxHeight: .infinity)
        }
#endif
    }

    @ViewBuilder
    var content: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .top) {
                    ForEach(cards, id: \.id) { card in
                        CardView(cardSide: .constant(cardsSide[card.id] ?? .front))
                    }
                }
                .rotation3DEffect(testViewModel.cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
                .rotation3DEffect(testViewModel.nextAnimation == .front ? .degrees(0): .degrees(-180), axis: (x: 0, y: 1, z: 0))
                HStack(alignment: .center) {
                    Spacer()
                    if testViewModel.showingFlipButton {
                        Button(action: {
                            testViewModel.showingFlipButton.toggle()
                            testViewModel.cardSide.toggle()
                        }) {
                            Text("Flip card")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .frame(width: geometry.size.width / 1.5, height: 45)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Button(action: {
                            cards.removeLast()
                            testViewModel.nextAnimation.toggle()
                            testViewModel.showingFlipButton.toggle()
                        }) {
                            Text("Correct")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .padding()
                        .frame(width: geometry.size.width / 3, height: 45)
                        .background(Color.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        Spacer()
                        Button(action: {
                            cards.removeLast()
                            testViewModel.nextAnimation.toggle()
                            testViewModel.showingFlipButton.toggle()
                        }) {
                            Text("Wrong")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.plain)
                        .padding()
                        .frame(width: geometry.size.width / 3, height: 45)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    Spacer()
                }
                
            }
            #if !os(iOS)
            .padding()
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
        .animation(.linear(duration: 0.5))
    }
    
    private struct CardView: View {
        @State var cardShadowColor = Color.getRandom()
        @Binding var cardSide: CardSide
        
        var body: some View {
            imageView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: cardShadowColor.opacity(0.8), radius: 20, x: 0, y: 10)
                .padding()
        }
        private var imageView: some View {
            AnimatedImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-McJEy9muc8IayNcbZe2%2Fcards%2F-MeGWTqzu0xwDRWYje8B%2FfrontImage.png?alt=media&token=1eb621ea-e311-4f81-8b59-b3ee625c8894")!)
                .indicator(SDWebImageActivityIndicator.gray)
                .resizable()
                .scaledToFit()
        }
    }
}
