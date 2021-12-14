//
//  Colors.swift
//  Voiceses
//
//  Created by Radi Barq on 26/03/2021.
//

import Foundation
import SwiftUI

fileprivate let randomColors: [Color] = [
    Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)),
    Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),
    Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
    Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
    Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
    Color(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)),
    Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)),
    Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
    Color(#colorLiteral(red: 0.6196078431, green: 0.4196078431, blue: 0.5764705882, alpha: 1)),
    Color(#colorLiteral(red: 1, green: 0.4509803922, blue: 0.4509803922, alpha: 1))
]

extension Color {
    public static let primary = Color(#colorLiteral(red: 0.1333333333, green: 0.2862745098, blue: 0.7019607843, alpha: 1))
    public static let secondary = Color(#colorLiteral(red: 0.6901960784, green: 0.7568627451, blue: 1, alpha: 1))
    public static let accent = Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
    public static func getRandom() -> Color {
        randomColors.randomElement()!
    }
    
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    var rgba: RGBA? {
        var (r,g,b,a): RGBA = (0,0,0,0)
        #if os(iOS)
            let uiColor = UIColor(self)
            return uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
        #else
            let nsColor = NSColor(self)
            nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            return (r,g,b,a)
        #endif
    }
    var hexaRGB: String? {
        guard let rgba = rgba else { return nil }
        return String(format: "#%02x%02x%02x",
                      Int(rgba.red*255),
                      Int(rgba.green*255),
                      Int(rgba.blue*255))
    }
    
    var isLightColor: Bool {
        guard let rgba = self.rgba else { return true }
        let lightRed = rgba.red > 0.65
        let lightGreen = rgba.green > 0.65
        let lightBlue = rgba.blue > 0.65
        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return lightness >= 2
    }
    
    var whiteOrBlack: Color {
        isLightColor ? .black : .white
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
