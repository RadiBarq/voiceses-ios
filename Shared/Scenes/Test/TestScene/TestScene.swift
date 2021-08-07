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
    @State private var cards = test_cards
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
                    ForEach($testCards, id: \.id) { card in
                        CardView(card: card)
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
                                .frame(width: geometry.size.width / 1.5, height: 45)
                                .background(Color.accent)
                        }
                        .buttonStyle(.plain)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Button(action: {
                            cards.removeLast()
                            testViewModel.nextAnimation.toggle()
                            testViewModel.showingFlipButton.toggle()
                        }) {
                            Text("Correct")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width / 3, height: 45)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .padding()
                        Spacer()
                        Button(action: {
                            cards.removeLast()
                            testViewModel.nextAnimation.toggle()
                            testViewModel.showingFlipButton.toggle()
                        }) {
                            Text("Wrong")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width / 3, height: 45)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .padding()
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
        @Binding var card: Card
        @State private var imageURL: URL?
        #if os(iOS)
        @State private var cachedImage: UIImage?
        #endif
        
        var body: some View {
            imageView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: cardShadowColor.opacity(0.8), radius: 20, x: 0, y: 10)
                .padding()
                .onAppear {
                    imageURL = card.frontImageURL
                    #if os(iOS)
                    cachedImage = GlobalService.shared.imageCache.image(for: "-front" + card.id)
                    #endif
                }
        }
        
        @ViewBuilder
        private var imageView: some View {
#if os(iOS)
        if self.cachedImage == nil {
            AnimatedImage(url: imageURL)
                .indicator(SDWebImageActivityIndicator.gray)
                .resizable()
                .scaledToFit()
        } else {
            Image(uiImage: cachedImage ?? UIImage())
                .resizable()
                .scaledToFit()
        }
#else
        AnimatedImage(url: imageURL)
            .indicator(SDWebImageActivityIndicator.gray)
            .resizable()
            .scaledToFit()
#endif
        }
    }
}
