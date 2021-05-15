//
//  Date+Extension.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import Foundation


extension Date {
    func getCurrentDateAsString() -> String {
        DateFormatter.getDefaultFormatter().string(from: self)
    }
}
