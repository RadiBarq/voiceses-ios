//
//  AddNewCardViewModel.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 01/05/2021.
//

import Foundation
import SwiftUI
import PencilKit
import Combine
import Firebase

enum CardSide: String {
    case front
    case back
    
    mutating func toggle() {
        self = self == .front ? .back : .front
    }
}

class AddNewCardViewModel: ObservableObject {
    @Published var cardSide: CardSide = .front
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    var parentColor: Color {
        Color(hex: subject.colorHex)
    }
    private let subject: Subject
    private var addNewCardImageService = FirebaseAddNewCardImageFirebaseService()
    private let addNewCardService = FirebaseAddNewCardService()
    private var subscriptions: Set<AnyCancellable> = []
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    func saveCanvasesImage(frontCanvas: PKCanvasView, backCanvas: PKCanvasView) {
        let imageRect = frontCanvas.frame
        let frontCanvasImage = frontCanvas.drawing.image(from: imageRect, scale: 1)
        let backCanvasImage = backCanvas.drawing.image(from: imageRect, scale: 1)
        let cardID = Database.database().reference().child("users").child("subjects")
            .child(subject.id!)
            .child("cards")
            .childByAutoId().key!
        let frontCanvasImagePublisher = addNewCardImageService.uploadImage(with: frontCanvasImage.pngData()!, subjectID: subject.id!, cardID: cardID, imageName: "frontImage")
        let backCanvasImagePublisher = addNewCardImageService.uploadImage(with: backCanvasImage.pngData()!, subjectID: subject.id!, cardID: cardID, imageName: "backImage")
        
        frontCanvasImagePublisher
            .combineLatest(backCanvasImagePublisher)
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else { return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { [weak self] (firstCardResult, secondCardResult) in
                guard let weakSelf = self else { return }
                let card = Card(id: cardID, subjectID: weakSelf.subject.id!, backImageURL: secondCardResult.0, frontImageURL: firstCardResult.0, dateCreated: Date().getCurrentDateAsString())
                weakSelf.addNewCardService.addNewCard(card: card)
                    .sink(receiveCompletion:{ [weak weakSelf] result in
                        guard let weakSelf = weakSelf else { return }
                        if case let .failure(error) = result {
                            weakSelf.alertMessage = error.errorDescription
                            weakSelf.showingAlert = true
                            return
                        }
                    },
                        receiveValue: {})
                    .store(in: &weakSelf.subscriptions)
            })
            .store(in: &subscriptions)
    }
}
