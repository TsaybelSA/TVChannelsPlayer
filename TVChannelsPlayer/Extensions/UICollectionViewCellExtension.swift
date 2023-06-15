//
//  UICollectionViewCellExtension.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension UICollectionViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
