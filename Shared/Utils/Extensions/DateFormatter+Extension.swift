//
//  DateFormatter+Extension.swift
//  Voiceses
//
//  Created by Radi Barq on 15/05/2021.
//

import Foundation

extension DateFormatter {
    static func getDefaultFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }
}
