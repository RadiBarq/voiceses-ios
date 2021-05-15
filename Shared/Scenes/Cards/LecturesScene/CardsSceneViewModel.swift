//
//  LecturesSceneViewModel.swift
//  Voiceses
//
//  Created by Radi Barq on 25/04/2021.
//

import Foundation
import Combine
import PencilKit


class CardsSceneViewModel: ObservableObject {
    @Published var cards = [Card]()
    @Published var showingAddNewCardView = false
  
    
    var title: String {
        subject.title
    }
    
    var subject: Subject
    
    init(subject: Subject) {
        self.subject = subject
    }
}
