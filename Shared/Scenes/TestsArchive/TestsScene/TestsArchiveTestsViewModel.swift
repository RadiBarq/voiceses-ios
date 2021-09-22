//
//  TestsArchiveTestsViewModel.swift
//  TestsArchiveTestsViewModel
//
//  Created by Radi Barq on 01/09/2021.
//

import Foundation
import Combine

class TestsArchiveTestsViewModel: ObservableObject {
    @Published var tests = [Test]()
    @Published var allTests = [Test]()
    @Published var sortOptions = SortOptions.ascend
    @Published var startDate = Date.startOfYesterday
    @Published var endDate = Date.endOfToday
    @Published var showingTestsArchiveFilterTestsScene = false
    @Published var showsLoadingIndicator = true
    @Published var isFilterApplied = false {
        didSet {
            if isFilterApplied {
                tests = allTests.filter {$0.timestamp >= startDate.timestamp && $0.timestamp <= endDate.timestamp }
            } else {
                tests = allTests
            }
            tests = sortOptions == .ascend ? tests.reversed() : tests
        }
    }
    
    private let getTestsForASubjectService = FirebaseGetTestsForASubjectService()
    private let deleteATestForASubjectService = FirebaseDeleteATestForASubjectService()
    private var subjectID: String?
    private var subscriptions = Set<AnyCancellable>()
    
    func getTests(for subject: Subject) {
        subjectID = subject.id
        let getTestsShared = getTestsForASubjectService.getTests(for: subject.id!).share()
        getTestsShared
            .map { [weak self] tests in
                var testsCopy = tests
                guard let weakSelf = self else { return [] }
                if weakSelf.isFilterApplied {
                    testsCopy = testsCopy.filter { $0.timestamp >= weakSelf.startDate.timestamp && $0.timestamp <= weakSelf.endDate.timestamp }
                }
                return (weakSelf.sortOptions == .ascend ? testsCopy.reversed() : testsCopy)
            }
            .replaceError(with: [])
            .assign(to: \.tests, on: self)
            .store(in: &subscriptions)
        
        getTestsShared
            .print("Test publisher")
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.showsLoadingIndicator = false
            }, receiveCompletion: { [weak self] _ in
                self?.showsLoadingIndicator = false
            }, receiveCancel: { [weak self] in
                self?.showsLoadingIndicator = false
            })
            .map {
                Array($0.reversed())
            }
            .replaceError(with: [])
            .assign(to: \.allTests, on: self)
            .store(in: &subscriptions)
    }
    
    func deleteTest(at offsets: IndexSet) {
        guard let subjectID = subjectID else {
            return
        }
        let testsIDsToDelete = offsets.map { tests[$0].id }
        for testID in testsIDsToDelete {
            deleteATestForASubjectService.delete(at: testID!, for: subjectID)
        }
        tests.remove(atOffsets: offsets)
    }
    
    func reverseCards() {
        sortOptions.toggle()
        tests.reverse()
    }
}
