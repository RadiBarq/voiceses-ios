//
//  SubjectSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 03/04/2021.
//

import Foundation
import Combine

class SubjectsSceneViewModel: ObservableObject {
    @Published var subjects = [Subject]() {
        didSet {
            searchedSubjects = subjects.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    @Published var searchedSubjects: [Subject] = []
    @Published var showLecturesOnMac = false
    @Published var showAddNewSubjectView = false
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showDeleteSubjectAlert = false
    @Published var selectedSubjectToBeDelete = ""
    @Published var searchText = "" {
        didSet {
            searchedSubjects = subjects.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var selectedMacSubject: Subject?
    private var subscriptions = Set<AnyCancellable>()
    private var getSubjectsService: FirebaseGetSubjectsService
    private var deleteASubjectService: FirebaseDeleteASubjectService
    private var updateSubjectService: FirebaseUpdateSubjectService
    
    init() {
        getSubjectsService = FirebaseGetSubjectsService()
        deleteASubjectService = FirebaseDeleteASubjectService()
        updateSubjectService = FirebaseUpdateSubjectService()
        startListenToGetSubjectsService()
    }
    
    func deleteSubject() {
        deleteASubjectService.deleteSubject(with: selectedSubjectToBeDelete)
    }

    func update(subject: Subject) {
        updateSubjectService.updateTitle(for: subject)
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
