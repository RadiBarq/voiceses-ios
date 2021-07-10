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

final class AddNewCardViewModel: ObservableObject {
    @Published var cardSide: CardSide = .front
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    var parentColor: Color {
        Color(hex: subject.colorHex)
    }
    private var subject: Subject
    private let addNewCardService = FirebaseAddNewCardService()
    private let updateSubjectService = FirebaseUpdateSubjectService()
    private var subscriptions: Set<AnyCancellable> = []
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    func saveCard(frontCanvas: PKCanvasView, backCanvas: PKCanvasView, isPresented: Binding<Bool>) {
        guard !isOneOfTheCanvasesEmpty(frontCanvas: frontCanvas, backCanvas: backCanvas) else  {
            showingAlert = true
            alertMessage = "You can't save an empty card side, make sure both sides are not empty."
            return
        }
        
        let imageRect = frontCanvas.frame
        let frontCanvasImage = frontCanvas.drawing.image(from: imageRect, scale: 1)
        let backCanvasImage = backCanvas.drawing.image(from: imageRect, scale: 1)
        let cardID = Database.database().reference().child("users").child("subjects")
            .child(subject.id!)
            .child("cards")
            .childByAutoId().key!
        let timestamp = Date.currentTimeStamp
        let date = Date().getCurrentDateAsString()
        let card = Card(id: cardID, subjectID: subject.id!, backImageURL: nil, frontImageURL: nil, dateCreated: date, timestamp: timestamp)
        GlobalService.shared.imageCache.insert(frontCanvasImage, for: "-front" + cardID)
        GlobalService.shared.imageCache.insert(backCanvasImage, for: "-back" + cardID)
        GlobalService.shared.saveCardImages(frontImage: frontCanvasImage.pngData()!, backImage: backCanvasImage.pngData()!, card: card)
        addNew(card: card)
        isPresented.wrappedValue = false
    }
    
    private func addNew(card: Card) {
        let result = self.addNewCardService.addNewCard(card: card)
        switch result {
        case .failure(let error):
            self.alertMessage = error.errorDescription
            self.showingAlert = true
        case .success:
            self.subject.numberOfCards! += 1
            self.updateSubjectService.updateNumberOfCards(for: self.subject)
        }
    }

    private func isOneOfTheCanvasesEmpty(frontCanvas: PKCanvasView, backCanvas: PKCanvasView) -> Bool {
        return frontCanvas.drawing.bounds.isEmpty || backCanvas.drawing.bounds.isEmpty
    }
}
