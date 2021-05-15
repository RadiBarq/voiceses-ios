//
//  CardView.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    let card: Card
    let deleteAction: () -> Void
    private let cornerRadius: CGFloat = 22
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        deleteAction()
                    }) {
                        Image(systemName: "trash.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button(action: {
                        deleteAction()
                    }) {
                        Image(systemName: "rotate.right.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding()
            .background(
                AnimatedImage(url: card.frontImageURL)
                    .indicator(SDWebImageActivityIndicator.medium)
                    .resizable()
                    .scaledToFit()
            )
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: testCards[0], deleteAction: {
        })
    }
}
