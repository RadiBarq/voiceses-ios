//
//  GlobalService.swift
//  Voiceses
//
//  Created by Radi Barq on 31/05/2021.
//

import Foundation
import Combine

final class GlobalService {
    static let shared = GlobalService()
    private var subsriptions: Set<AnyCancellable> = []
    private var addNewCardImageService = FirebaseAddNewCardImageFirebaseService()
    private let addNewCardService = FirebaseAddNewCardService()
    let imageCache = ImageCache()
    
    func saveCardImages(frontImage: Data, backImage: Data, card: Card) {
        var cardCopy = card
        let frontCanvasImagePublisher = addNewCardImageService.uploadImage(with: frontImage, subjectID: card.subjectID, cardID: card.id, imageName: "frontImage")
        let backCanvasImagePublisher = addNewCardImageService.uploadImage(with: backImage, subjectID: card.subjectID, cardID: card.id, imageName: "backImage")
        frontCanvasImagePublisher
            .combineLatest(backCanvasImagePublisher)
            .sink(receiveCompletion: { result in

                if case let .failure(error) = result {
                    print(error)
                    return
                }
            }, receiveValue: { [weak self] (firstCardResult, secondCardResult) in
                guard let weakSelf = self else { return }
                cardCopy.backImageURL = secondCardResult.0
                cardCopy.frontImageURL = firstCardResult.0
                weakSelf.addNewCardService.addNewCard(card: cardCopy)
                    .sink(receiveCompletion:{ result in
                        if case let .failure(error) = result {
                            print(error)
                            return
                        }
                    },
                    receiveValue: {})
                    .store(in: &weakSelf.subsriptions)
            })
            .store(in: &subsriptions)
    }
}
