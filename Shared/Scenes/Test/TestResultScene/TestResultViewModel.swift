//
//  TestResultViewModel.swift
//  TestResultViewModel
//
//  Created by Radi Barq on 23/09/2021.
//

import Foundation
import SwiftUI

class TestResultViewModel: ObservableObject {
    @Published var testResult: String = ""
    @Published var testResultColor = Color.green
    @Published var testsArchivesCardPushed = false
    func setupTestInformation(with result: Double) {
        testResult = String(format: "%.2f", result) + "%"
        if result >= 0 && result < 50 {
            testResultColor = .red
        } else if result >= 50 && result < 80 {
            testResultColor = .yellow
        } else if result >= 80 && result <= 100{
            testResultColor = .green
        } else {
            testResultColor = .clear
        }
    }
}
