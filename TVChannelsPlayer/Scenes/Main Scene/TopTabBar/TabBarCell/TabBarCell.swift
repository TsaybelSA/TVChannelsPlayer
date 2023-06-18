//
//  TabBarCell.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 12.06.2023.
//

import UIKit

class TabBarCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    private var _isSelected = false
    override var isSelected: Bool {
        get { _isSelected }
        set {
            _isSelected = newValue
            setupForState(newValue)
        }
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = .roboto.bold(16)
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
    
    private func setupForState(_ isSelected: Bool) {
        title.textColor = isSelected ? .white : .white.withAlphaComponent(0.5)
    }
}
