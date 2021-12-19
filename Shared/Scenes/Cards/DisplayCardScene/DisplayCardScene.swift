//
//  ViewCardScene.swift
//  Voiceses
//
//  Created by Radi Barq on 16/06/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct DisplayCardScene: View {
    @State private var imageURL: URL?
#if os(iOS)
    @State private var cachedImage: UIImage?
#else
    @Binding var isPresented: Bool
#endif
    
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var displayCardViewModel: DisplayCardViewModel
    var body: some View {
        VStack {
            imageView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .rotation3DEffect(displayCardViewModel.cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
        .shadow(color: colorScheme == .light ? displayCardViewModel.shadowColor.opacity(0.6) : .clear, radius: 20, x: 0, y: 10)
        .navigationTitle("\(displayCardViewModel.cardSide.rawValue.capitalized) side")
        .animation(.easeInOut(duration: 0.5), value: displayCardViewModel.cardSide)
#if !os(iOS)
        .animation(.default, value: isPresented)
#endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    displayCardViewModel.cardSide.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        imageURL = displayCardViewModel.cardSide == .back ? displayCardViewModel.card.backImageURL : displayCardViewModel.card.frontImageURL
                        #if os(iOS)
                        let cardSideName = "-\(displayCardViewModel.cardSide)"
                        cachedImage = GlobalService.shared.imageCache.image(for: cardSideName + displayCardViewModel.card.id)
                        #endif
                    }
                }, label: {
                    Text("Switch side")
                })
            }
#if !os(iOS)
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Image(systemName: "chevron.backward")
                })
            }
#endif
        }
        .padding()
        .onAppear {
            imageURL = displayCardViewModel.cardSide == .front ? displayCardViewModel.card.frontImageURL : displayCardViewModel.card.backImageURL
            
#if os(iOS)
            cachedImage = GlobalService.shared.imageCache.image(for: "-front" + displayCardViewModel.card.id)
#endif
        }
    }
    
    @ViewBuilder
    var imageView: some View {
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
