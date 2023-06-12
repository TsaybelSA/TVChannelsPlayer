//
//  ArrayExtension.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import Foundation

extension Array {
    func safelyGetItem(at index: Int) -> Element? {
        guard !self.isEmpty && index >= 0 && self.count > index else { return nil }
        
        return self[index]
    }
}
