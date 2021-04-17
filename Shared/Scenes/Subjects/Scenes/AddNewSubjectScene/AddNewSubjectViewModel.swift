//
//  AddNewSubjectViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation
import Combine
import SwiftUI

final class AddNewSubjectViewModel: ObservableObject {
    @Published var color: Color
    @Published var isDoneButtonDisabled: Bool
    @Published var showingAlert: Bool
    @Published var alertMessage: String
    @Published var name: String {
        didSet {
            isDoneButtonDisabled = name.isEmpty
        }
    }
    private let addNewSubjectService: FirebaseAddNewSubjectService
    private var subscriptions: Set<AnyCancellable>
    init() {
        self.color = Color.getRandom()
        self.isDoneButtonDisabled = true
        self.showingAlert = false
        self.alertMessage = ""
        self.name = ""
        self.addNewSubjectService = FirebaseAddNewSubjectService()
        self.subscriptions = []
    }

    func doneButtonClicked() {
        let subject = Subject(title: name, numberOfLectures: 0, colorHex: color.hexaRGB ?? Color.getRandom().hexaRGB!)
        self.addNewSubjectService.addNewSubject(subject: subject)
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else { return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
    }
}
