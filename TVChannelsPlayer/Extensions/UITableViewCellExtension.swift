//
//  UITableViewCellExtension.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import UIKit

extension UITableViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
