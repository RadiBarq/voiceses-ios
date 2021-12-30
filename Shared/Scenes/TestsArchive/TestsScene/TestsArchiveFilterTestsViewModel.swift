//
//  TestsArchiveFilterTestsViewModel.swift
//  TestsArchiveFilterTestsViewModel
//
//  Created by Radi Barq on 06/09/2021.
//

import Foundation

class TestsArchiveFilterTestsViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    
    func isSelectedDateValid(from startDate: Date, to endDate: Date) -> Bool {
        return endDate >= startDate
    }
    
    func showInvalidSelectedDateMessage() {
        showingAlert = true
        alertMessage = "Invalid selected custom date range, make sure that the end date is greater than or equal the start date."
    }
}
