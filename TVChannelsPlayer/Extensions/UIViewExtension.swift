//
//  UIViewExtension.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import UIKit

extension UIView {
    func attachView(_ viewToAttach: UIView, edgeInsets: UIEdgeInsets = .zero) {
        addSubview(viewToAttach)
        
        NSLayoutConstraint.activate([
            viewToAttach.leftAnchor.constraint(equalTo: leftAnchor, constant: edgeInsets.left),
            viewToAttach.rightAnchor.constraint(equalTo: rightAnchor, constant: edgeInsets.right),
            viewToAttach.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top),
            viewToAttach.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeInsets.bottom)
        ])
    }
}
