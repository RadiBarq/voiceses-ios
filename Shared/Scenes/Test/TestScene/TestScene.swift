//
//  TestScene.swift
//  Voiceses
//
//  Created by Radi Barq on 25/07/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct TestScene: View {
    @Binding var isPresented: Bool
    @Binding var testIncludedCardsStartDate: Date
    @Binding var testIncludedCardsEndDate: Date
    @Binding var testIncludedCardsOption: TestIncludedCardsOption
    @Binding var testSelectedDateFitlerOption: DateFilterOption
    @Binding var testSelectedCardsOrderOption: TestCardsOrderOption
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
    
    var content: some View {
        GeometryReader { geometry in
            VStack {
                imageView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: testViewModel.cardShadowColor.opacity(0.8), radius: 20, x: 0, y: 10)
                    .padding()
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    if testViewModel.showingFlipButton {
                        Button(action: {
                            testViewModel.showingFlipButton.toggle()
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
    }
    
    var imageView: some View {
        AnimatedImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/voiceses-99761.appspot.com/o/users%2F7tWnL6JKhAUn4QtuwcNeSrXfiAn2%2Fsubjects%2F-McJEy9muc8IayNcbZe2%2Fcards%2F-MeGWTqzu0xwDRWYje8B%2FfrontImage.png?alt=media&token=1eb621ea-e311-4f81-8b59-b3ee625c8894")!)
            .indicator(SDWebImageActivityIndicator.gray)
            .resizable()
            .scaledToFit()
    }
}
