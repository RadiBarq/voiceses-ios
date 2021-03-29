//
//  Encodable+Extension.swift
//  Voiceses
//
//  Created by Radi Barq on 28/03/2021.
//

import Foundation

extension Encodable {
  func getDictionary() -> [String: Any]? {
    let encoder = JSONEncoder()
    guard let data = try? encoder.encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any]
    }
  }
}
