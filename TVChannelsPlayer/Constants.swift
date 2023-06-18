//
//  Constants.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 10.06.2023.
//

import UIKit

// Screen width.
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

public var isRuLocale: Bool {
    NSLocale.preferredLanguages.first == "ru"
}

struct Colors {
    static let mainBackgroundColor = UIColor(named: "mainBackgroundColor")
    static let secondaryBackgroundColor = UIColor(named: "secondaryBackgroundColor")
    static let inactiveElementColor = UIColor(named: "inactiveElementColor")
    static let channelTitleColor = UIColor.white
    static let currentProgramColor = #colorLiteral(red: 0.9309120178, green: 0.934602797, blue: 0.9500084519, alpha: 1)
}

struct Size {
    static let channelRowHeight: CGFloat = 76
    static let navBarHeight: CGFloat = 76
}
