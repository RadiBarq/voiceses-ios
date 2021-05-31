//
//  CardView.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    @Binding var card: Card
    let deleteAction: () -> Void
    @State var cardSide: CardSide = .front
    private let cornerRadius: CGFloat = 22
    @State private var imageURL: URL?
    @State private var cachedImage: UIImage?
    
    var body: some View {
            VStack {
                if cardSide == .back {
                    Spacer()
                }
                HStack {
                    Button(action: {
                        deleteAction()
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                            .rotation3DEffect(cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action:  {
                        cardSide.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            imageURL = cardSide == .back ? card.backImageURL : card.frontImageURL
                            cachedImage = GlobalService.shared.imageCache.image(for: "-back" + card.id)
                        }
                    }) {
                        Image(systemName: "rotate.right.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                            .rotation3DEffect(cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                if cardSide == .front {
                    Spacer()
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(
                backgroundView

            )
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .rotation3DEffect(cardSide == .front ? .degrees(0): .degrees(-180), axis: (x: 1, y: 0, z: 0))
            .onAppear {
                imageURL = card.frontImageURL
                cachedImage = GlobalService.shared.imageCache.image(for: "-front" + card.id)
            }
    }
    
    @ViewBuilder
    var backgroundView: some View {
        if self.cachedImage == nil {
            AnimatedImage(url: imageURL)
                .placeholder(cachedImage)
                .indicator(SDWebImageActivityIndicator.gray)
                .resizable()
                .scaledToFit()
        } else {
            Image(uiImage: cachedImage ?? UIImage())
                .resizable()
                .scaledToFit()
        }
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .constant(testCards[0]) , deleteAction: {
        })
    }
}
