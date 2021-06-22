//
//  LecturesSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 25/04/2021.
//

import Foundation
import Combine
import PencilKit

class CardsSceneViewModel: ObservableObject {
    @Published var cards = [Card]()
    @Published var showingAddNewCardView = false
    @Published var showAddNewSubjectView = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    private var subscriptions = Set<AnyCancellable>()
    private var getCardsService: FirebaseGetCardsService
    private var deleteCardService: FirebaseDeleteACardService
    private var updateSubjectService: FirebaseUpdateSubjectService
    var title: String {
        subject.title
    }
    var subject: Subject
    
    init(subject: Subject) {
        self.subject = subject
        getCardsService = FirebaseGetCardsService(subjectID: subject.id!)
        deleteCardService = FirebaseDeleteACardService()
        updateSubjectService = FirebaseUpdateSubjectService()
        startListenToGetCardsService()
    }
    
    func deleteCard(with id: String) {
        deleteCardService.deleteCard(with: id, subjectID: subject.id!)
        subject.numberOfCards! -= 1
        updateSubjectService.updateNumberOfCards(for: subject)
        GlobalService.shared.deleteCardImages(with: id, subjectID: subject.id!)
    }
    private func startListenToGetCardsService() {
        getCardsService
            .cards?
            .replaceError(with: [])
            .assign(to: \.cards, on: self)
            .store(in: &subscriptions)

        getCardsService
            .cards?
            .ignoreOutput()
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else { return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
}
