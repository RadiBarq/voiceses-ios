//
//  ViewCardScene.swift
//  Voiceses
//
//  Created by Radi Barq on 16/06/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ViewCardsScene: View {
    var card: Card
    @State private  var cardSide: CardSide = .front
    @State private var imageURL: URL?
#if os(iOS)
    @State private var cachedImage: UIImage?
#endif
    var body: some View {
        VStack {
            imageView
        }
        .cornerRadius(25)

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
