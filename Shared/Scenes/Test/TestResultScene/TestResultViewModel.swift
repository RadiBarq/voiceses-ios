//
//  TestResultViewModel.swift
//  TestResultViewModel
//
//  Created by Radi Barq on 23/09/2021.
//

import Foundation

class TestResultViewModel: ObservableObject {
    @Published var testResult: String = ""
    func calculateTestResult() {
        // Here we calculate the test result.
        testResult = "90%"
    }
}
