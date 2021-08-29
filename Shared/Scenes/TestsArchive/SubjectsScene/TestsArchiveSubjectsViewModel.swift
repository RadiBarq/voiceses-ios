//
//  TestArchiveSubjectsViewModel.swift
//  TestArchiveSubjectsViewModel
//
//  Created by Radi Barq on 29/08/2021.
//

import Foundation
import Combine

class TestsArchiveSubjectsViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var searchedSubjects = [Subject]()
    @Published var searchText = "" {
        didSet {
            searchedSubjects = subjects.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private var subjects = [Subject]() {
        didSet {
            searchedSubjects = subjects.filter { searchText.isEmpty ? true : $0.title.lowercased().contains(searchText.lowercased()) }
        }
        
    }
    private let getAddedSubjectsService: FirebaseGetAddedSubjectsService
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        getAddedSubjectsService = FirebaseGetAddedSubjectsService()
        startListenToAddedSubjectsService()
    }
    
    private func startListenToAddedSubjectsService() {
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
}
