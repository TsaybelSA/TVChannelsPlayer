//
//  StringExtensions.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import Foundation

extension String {
    public var localized: String {
        let value = NSLocalizedString(self, comment: "")
        if value != self || NSLocale.preferredLanguages.first == "en" {
            return value
        }
        
        guard let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
            let bundle = Bundle(path: path) else { return value }
        
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
