//
//  SetupTestViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 15/07/2021.
//

import Foundation

class SetupTestViewModel: ObservableObject {
    @Published var includedCardsStartDate = Date.startOfYesterday
    @Published var includedCardsEndDate = Date.endOfToday
    @Published var selectedTestIncludedCards =  TestIncludedCardsOption.allCards
    @Published var selectedDateFitlerOption = DateFilterOption.today
    @Published var selectedTestCardsOrderOption = TestCardsOrderOption.smartOrder
}
