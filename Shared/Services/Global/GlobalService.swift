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
    
    #if os(iOS)
    private var addNewCardImageService = FirebaseAddNewCardImageFirebaseService()
    private let addNewCardService = FirebaseAddNewCardService()
    let imageCache = ImageCache()
    #endif
    
    private var deleteCardImageService = FirebaseDeleteCardImageService()
    private var firebaseDeleteSubjectImagesService = FirebaseDeleteSubjectImagesService()

    #if os(iOS)
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
                let result = weakSelf.addNewCardService.addNewCard(card: cardCopy)
                if case let .failure(error) = result {
                    print(error)
                }
            })
            .store(in: &subsriptions)
    }
    #endif

    func deleteCardImages(with cardID: String, subjectID: String) {
        let deleteFrontImagePublisher = deleteCardImageService.deleteImage(with: "frontImage.png", cardID: cardID, subjectID: subjectID)
        let deleteBackImagePublihser = deleteCardImageService.deleteImage(with: "backImage.png", cardID: cardID, subjectID: subjectID)
        
        deleteFrontImagePublisher
            .combineLatest(deleteBackImagePublihser)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            }, receiveValue: { _ in
            })
            .store(in: &subsriptions)
    }

    func deleteSubjectImages(with subjectID: String) {
        firebaseDeleteSubjectImagesService.deleteImages(for: subjectID)
    }
}
