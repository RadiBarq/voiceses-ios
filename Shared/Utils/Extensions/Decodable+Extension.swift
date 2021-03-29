//
//  Decodable+Extension.swift
//  Voiceses
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation

extension Decodable {
  init?(dictionary value: [String:Any]){
    guard JSONSerialization.isValidJSONObject(value) else { return nil }
    guard let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) else { return nil }

    guard let newValue = try? JSONDecoder().decode(Self.self, from: jsonData) else { return nil }
    self = newValue
  }
}
