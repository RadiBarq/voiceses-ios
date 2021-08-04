//
//  TestModel.swift
//  Voiceses
//
//  Created by Radi Barq on 25/07/2021.
//

import Foundation
import Combine
import SwiftUI

class TestModel: ObservableObject {
    @Published var showingFlipButton = true
    @Published var cardShadowColor = Color.getRandom()
    @Published var cardSide: CardSide = .front
    @Published var nextAnimation: CardSide = .front
}
