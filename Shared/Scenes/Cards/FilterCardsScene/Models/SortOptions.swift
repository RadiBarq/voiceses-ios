//
//  SortOptions.swift
//  Voiceses (iOS)
//
//  Created by Radi Barq on 01/07/2021.
//

import Foundation

enum SortOptions {
    case ascend
    case descend
    mutating func toggle() {
        self = self == .ascend ? .descend : .ascend
    }
}
