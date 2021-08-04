//
//  SetupTestViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 05/08/2021.
//

import Foundation

final class SetupTestViewModel: ObservableObject {
    @Published var testIncludedCardsStartDate = Date.startOfYesterday
    @Published var testIncludedCardsEndDate = Date.endOfToday
    @Published var testIncludedCardsOption =  TestIncludedCardsOption.allCards
    @Published var testSelectedDateFitlerOption = DateFilterOption.today
    @Published var testSelectedCardsOrderOption = TestCardsOrderOption.smartOrder
    
    
    
}
