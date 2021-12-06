//
//  TestScene.swift
//  Voiceses
//
//  Created by Radi Barq on 25/07/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct TestScene: View {
    @Binding var cards: [Card]
    @Binding var isPresented: Bool
    @Binding var showsTestResultScene: Bool
    @Binding var testResult: Double
    @Binding var test: Test?
    @StateObject private var testViewModel = TestViewModel()
    @State private var cancellationConfiratmion = false
    var subjectID: String?
    var body: some View {
#if os(iOS)
        NavigationView {
            content
                .accentColor(Color.accent)
                .navigationTitle("\(testViewModel.currentCard) out of \(testViewModel.testCardsCount ?? 0)")
        }
#else
        ScrollView {
            Text("\(testViewModel.currentCard) out of \(testViewModel.testCardsCount ?? 0)")
                .font(.headline)
                .padding()
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
                    ForEach($testViewModel.testCards, id: \.id) { card in
                        let isFrontCard = testViewModel.isFrontCard(card: card.wrappedValue)
                        CardView(isFrontCard: .constant(isFrontCard), card: card, cardSide: $testViewModel.cardSide)
                    }
                }
                .rotation3DEffect(testViewModel.nextAnimation == .front ? .degrees(0): .degrees(360), axis: (x: 0, y: 1, z: 0))
                .rotation3DEffect(testViewModel.cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
                HStack(alignment: .center) {
                    Spacer()
                    if testViewModel.showingFlipButton {
                        Button(action: {
                            testViewModel.showingFlipButton.toggle()
                            testViewModel.showingCorrectAndWrongButtons.toggle()
                            testViewModel.cardSide.toggle()
                            DispatchQueue.main.async {
                                testViewModel.isCorrectAndWrongButtonsDisabled.toggle()
                            }
                        }) {
                            Text("Flip card")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width / 1.5, height: 45)
                                .background(Color.accent)
                        }
                        .buttonStyle(.plain)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                        
                    } else if testViewModel.showingCorrectAndWrongButtons {
                        Button(action: {
                            guard testViewModel.isCorrectAndWrongButtonsDisabled == false else {
                                return
                            }
                            testViewModel.isCorrectAndWrongButtonsDisabled.toggle()
                            testViewModel.showingCorrectAndWrongButtons.toggle()
                            testViewModel.cardSide.toggle()
                            testViewModel.addCorrectAnswer(card: testViewModel.testCards.last!)
                            
                            if testViewModel.testCards.count == 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    guard let subjectID = subjectID else {
                                        testViewModel.addTestResultLocally(isPresented: $isPresented, showsTestResultScene: $showsTestResultScene, test: $test)
                                        return
                                    }
                                    testViewModel.addTestResult(subjectID: subjectID, isPresented: $isPresented, showsTestResultScene: $showsTestResultScene, test: $test)
                                }
                            }
                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                testViewModel.nextAnimation.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                testViewModel.testCards.removeLast()
                                testViewModel.currentCard += 1
                                testViewModel.showingFlipButton.toggle()
                            }
                        }) {
                            Text("Correct")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width / 3, height: 45)
                                .background(Color.green)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .padding()
                        .disabled(testViewModel.isCorrectAndWrongButtonsDisabled)
                        Spacer()
                        Button(action: {
                            guard !testViewModel.isCorrectAndWrongButtonsDisabled else {
                                return
                            }
                            testViewModel.isCorrectAndWrongButtonsDisabled.toggle()
                            testViewModel.showingCorrectAndWrongButtons.toggle()
                            testViewModel.cardSide.toggle()
                            testViewModel.addWrongAnswer(card: testViewModel.testCards.last!)
                            
                            if testViewModel.testCards.count == 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    guard let subjectID = subjectID else {
                                        testViewModel.addTestResultLocally(isPresented: $isPresented, showsTestResultScene: $showsTestResultScene, test: $test)
                                        return
                                    }
                                    testViewModel.addTestResult(subjectID: subjectID,
                                                                isPresented: $isPresented, showsTestResultScene: $showsTestResultScene,
                                                                test: $test)
                                }
                            }
                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                testViewModel.nextAnimation.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                testViewModel.testCards.removeLast()
                                testViewModel.currentCard += 1
                                testViewModel.showingFlipButton.toggle()
                            }
                        }) {
                            Text("Wrong")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width / 3, height: 45)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                        .padding()
                        .disabled(testViewModel.isCorrectAndWrongButtonsDisabled)
                    }
                    Spacer()
                }
            }
#if !os(iOS)
            .padding()
#endif
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: {
                        cancellationConfiratmion.toggle()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
        .animation(.linear.delay(0.1), value: testViewModel.cardSide)
        .animation(.linear.delay(0.1), value: testViewModel.currentCard)
        .animation(.linear.delay(0.1), value: testViewModel.nextAnimation)
        .animation(.linear.delay(0.1), value: testViewModel.testCards)
        .onAppear {
            testViewModel.testCardsCount = cards.count
            testViewModel.testCards = cards
            testViewModel.allTestCards = cards
        }
        .alert(isPresented: $testViewModel.showingAlert) {
            Alert(title: Text(alertTitle),
                  message: Text(testViewModel.alertMessage),
                  dismissButton: .default(Text(alertDismissButtonTitle))
            )
        }
        .confirmationDialog(
            "Are you sure you want to cancel the test!, your progress will not be saved.",
            isPresented: $cancellationConfiratmion,
            titleVisibility: .visible) {
            Button("Yes", role: .destructive) {
                isPresented.toggle()
            }
        }
    }
    
    private struct CardView: View {
        @Binding var isFrontCard: Bool
        @Binding var card: Card
        @Binding var cardSide: CardSide
        @State private var imageURL: URL?
        @State private var cardShadowColor: Color = Color.getRandom().opacity(0.6)
        @Environment(\.colorScheme) private var colorScheme
#if os(iOS)
        @State private var cachedImage: UIImage?
#endif
        var body: some View {
            imageView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: colorScheme == .light ? (isFrontCard ? cardShadowColor : .clear) : .clear,
                    radius: 20, x: 0, y: cardSide == .front ? 10 : -10)
                .padding()
                .onChange(of: cardSide) { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        imageURL = newValue == .back ? card.backImageURL : card.frontImageURL
#if os(iOS)
                        cachedImage =  GlobalService.shared.imageCache.image(for: "-\(newValue.rawValue)" + card.id)
#endif
                    }
                }
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
