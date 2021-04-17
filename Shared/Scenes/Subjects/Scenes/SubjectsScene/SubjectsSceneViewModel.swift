//
//  SubjectSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 03/04/2021.
//

import Foundation
import Combine

class SubjectsSceneViewModel: ObservableObject {
    @Published var subjects = [Subject]()
    @Published var showLecturesOnMac = false
    @Published var showAddNewSubjectView = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showDeleteSubjectAlert = false
    @Published var selectedSubjectToBeDelete = ""
    
    private var subscriptions = Set<AnyCancellable>()
    private var getSubjectsService: FirebaseGetSubjectsService
    private var deleteASubjectService: FirebaseDeleteASubjectService
    
    init() {
        getSubjectsService = FirebaseGetSubjectsService()
        deleteASubjectService = FirebaseDeleteASubjectService()
        startListenToGetSubjectsService()
    }
    
    func deleteSubject() {
        deleteASubjectService.deleteSubject(with: selectedSubjectToBeDelete)
    }
    
    private func startListenToGetSubjectsService() {
        getSubjectsService
            .subjects
            .replaceError(with: [])
            .assign(to: \.subjects, on: self)
            .store(in: &subscriptions)
        
        getSubjectsService
            .subjects
            .ignoreOutput()
            .sink(receiveCompletion: { [weak self] result in
                guard let weakSelf = self else { return }
                if case let .failure(error) = result {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: {_ in })
            .store(in: &subscriptions)
    }
}
