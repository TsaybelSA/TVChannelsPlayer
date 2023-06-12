//
//  TabBarCell.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension TabBarCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class TabBarCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    func setTitle(_ titleText: String) {
        title.text = titleText
    }
    
    private func setup() {
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
