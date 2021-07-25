//
//  SubjectSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 03/04/2021.
//

import Foundation
import Combine

final class SubjectsViewModel: ObservableObject {
    @Published var subjects = [Subject]() {
        didSet {
            searchedSubjects = subjects.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    @Published var searchedSubjects: [Subject] = []
    @Published var showingLecturesOnMac = false
    @Published var showingAddNewSubjectScene = false
    @Published var showingAlert = false
    @Published var showingTestSetupScene = false
    @Published var alertMessage = ""
    @Published var showDeleteSubjectAlert = false
    @Published var selectedSubjectIDToBeDeleted = ""
    @Published var sortOptions = SortOptions.ascend {
        didSet {
            subjects.reverse()
        }
    }
    @Published var searchText = "" {
        didSet {
            searchedSubjects = subjects.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var selectedMacSubject: Subject?
    private var subscriptions = Set<AnyCancellable>()
    private var getAddedSubjectsService: FirebaseGetAddedSubjectsService
    private var getUpdatedSubjectsService: FirebaseGetUpdatedSubjectsService
    private var getDeletedSubjectsService: FirebaseGetDeletedSubjectsService
    private var deleteASubjectService: FirebaseDeleteASubjectService
    private var updateSubjectService: FirebaseUpdateSubjectService
    
    init() {
        getAddedSubjectsService = FirebaseGetAddedSubjectsService()
        deleteASubjectService = FirebaseDeleteASubjectService()
        updateSubjectService = FirebaseUpdateSubjectService()
        getDeletedSubjectsService = FirebaseGetDeletedSubjectsService()
        getUpdatedSubjectsService = FirebaseGetUpdatedSubjectsService()
        startListenToGetAddedSubjectsService()
        startListenToGetDeletedSubjectsService()
        startListenToGetUpdatedSubjectsService()
    }
    
    func deleteSubject() {
        deleteASubjectService.deleteSubject(with: selectedSubjectIDToBeDeleted)
        GlobalService.shared.deleteSubjectImages(with: selectedSubjectIDToBeDeleted)
    }
    
    func update(subject: Subject) {
        updateSubjectService.updateTitle(for: subject)
    }
    
    func reverseSubjects() {
        sortOptions.toggle()
    }
    
    private func startListenToGetAddedSubjectsService() {
        getAddedSubjectsService
            .subjects?
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                if case let .failure(error) = completion {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { [weak self] subject in
                self?.subjects.append(subject)
            })
            .store(in: &subscriptions)
    }
    
    private func startListenToGetDeletedSubjectsService() {
        getDeletedSubjectsService
            .deletedSubjects?
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                if case let .failure(error) = completion {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { [weak self] deletedSubject in
                self?.subjects.removeAll(where: { $0.id == deletedSubject.id })
            })
            .store(in: &subscriptions)
    }
    
    private func startListenToGetUpdatedSubjectsService() {
        getUpdatedSubjectsService
            .updatedSubjects?
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                if case let .failure(error) = completion {
                    weakSelf.alertMessage = error.errorDescription
                    weakSelf.showingAlert = true
                    return
                }
            }, receiveValue: { [weak self] updatedSubject in
                guard let weakSelf = self, let index = weakSelf.subjects.firstIndex(where: { $0.id == updatedSubject.id })
                else { return }
                weakSelf.subjects[index] = updatedSubject
            })
            .store(in: &subscriptions)
    }
}
