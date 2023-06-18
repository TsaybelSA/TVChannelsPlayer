//
//  Fonts.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import UIKit

extension UIFont {
    static let roboto = CustomFont("Roboto")
}

class CustomFont {
    
    enum Width: String, CaseIterable {
        case regular = "-Regular"
        case bold = "-Bold"
        case medium = "-Medium"
        case italic = "-Italic"
        case boldItalic = "-BoldItalic"
        case black = "-Black"
        case extrabold = "-ExtraBold"
        case semibold = "-SemiBold"
        case light = "-Light"
    }
    
    let familyName: String
    
    init(_ familyName: String) {
        self.familyName = familyName
    }
    
    func regular(_ size: CGFloat) -> UIFont {
        createFont(weight: .regular, size: size)
    }
    
    func bold(_ size: CGFloat) -> UIFont {
        createFont(weight: .bold, size: size)
    }
    
    func medium(_ size: CGFloat) -> UIFont {
        createFont(weight: .medium, size: size)
    }
    
    func black(_ size: CGFloat) -> UIFont {
        createFont(weight: .black, size: size)
    }
    
    func semibold(_ size: CGFloat) -> UIFont {
        createFont(weight: .semibold, size: size)
    }
    
    func extrabold(_ size: CGFloat) -> UIFont {
        createFont(weight: .extrabold, size: size)
    }
    
    func light(_ size: CGFloat) -> UIFont {
        createFont(weight: .light, size: size)
    }
    
    func italic(_ size: CGFloat) -> UIFont {
        createFont(weight: .italic, size: size)
    }
    
    func boldItalic(_ size: CGFloat) -> UIFont {
        createFont(weight: .boldItalic, size: size)
    }
    
    private func createFont(weight: CustomFont.Width, size: CGFloat) -> UIFont {
        UIFont(name: familyName + weight.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
