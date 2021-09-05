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
    @Published var sortOptions = SortOptions.ascend
    @Published var startDate = Date.startOfYesterday
    @Published var endDate = Date.endOfToday
    private let getTestsForASubjectService = FirebaseGetTestsForASubjectService()
    private let deleteATestForASubjectService = FirebaseDeleteATestForASubjectService()
    private var subjectID: String?
    private var subscriptions = Set<AnyCancellable>()
    
    func getTests(for subject: Subject) {
        subjectID = subject.id
        getTestsForASubjectService.getTests(for: subject.id!)
            .map {
                Array($0.reversed())
            }
            .replaceError(with: [])
            .assign(to: \.tests, on: self)
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
