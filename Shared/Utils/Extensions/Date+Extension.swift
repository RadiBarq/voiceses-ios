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
    
    static var currentTimeStamp: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}