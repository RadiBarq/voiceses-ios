//
//  SetupTestViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 05/08/2021.
//

import Foundation
import SwiftUI

final class SetupTestViewModel: ObservableObject {
    @Published var testIncludedCardsStartDate = Date.startOfYesterday
    @Published var testIncludedCardsEndDate = Date.endOfToday
    @Published var testSelectedDateFitlerOption = DateFilterOption.today
    @Published var testIncludedCardsOption =  TestIncludedCardsOption.allCards
    @Published var testSelectedCardsOrderOption = TestCardsOrderOption.smartOrder
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    func applyCardsFilterAndOrder(to cards: Binding<[Card]>) -> Bool {
        if testIncludedCardsOption == .filteredCards {
            if isSelectedFilterDateValid(from: testIncludedCardsStartDate, to: testIncludedCardsEndDate) {
                filterCards(cards: cards)
                return true
            } else {
                showInvalidIncludedCardsDateSelected()
                return false
            }
        }
        
        if testSelectedCardsOrderOption == .smartOrder {
            applyCardsSmartOrder(to: cards)
        }
        return true
    }
    
    private func isSelectedFilterDateValid(from startDate: Date, to endDate: Date) -> Bool {
        return endDate >= startDate
    }
    
    private func filterCards(cards: Binding<[Card]>) {
        let (startDate, endDate) = self.getFirstAndEndTimestampsOfIncludedCardsDate()
        cards.wrappedValue = cards.wrappedValue.filter {
            $0.timestamp >= startDate && $0.timestamp <= endDate
        }
    }
    
    private func applyCardsSmartOrder(to cards: Binding<[Card]>) {
        cards.wrappedValue = cards.wrappedValue.sorted {
            $0.testScore > $1.testScore
        }
    }
    
    private func showInvalidIncludedCardsDateSelected() {
        showingAlert = true
        alertMessage = "Invalid selected custom date range, make sure that the end date is greater than or equal the start date."
    }
    
    private func getFirstAndEndTimestampsOfIncludedCardsDate() -> (Int64, Int64) {
        var startDate: Date
        var endDate: Date
        switch testSelectedDateFitlerOption {
        case .today:
            startDate = .startOfToday
            endDate = .endOfToday
        case .last7Days:
            startDate = .startOfSevenDaysAgo
            endDate = .endOfToday
        case .last30Days:
            startDate = .startOfThirtyDaysAgo
            endDate = .endOfToday
        case .customDate:
            startDate = testIncludedCardsStartDate
            endDate = testIncludedCardsEndDate
        }
        return (startDate.timestamp, endDate.timestamp)
    }
}
