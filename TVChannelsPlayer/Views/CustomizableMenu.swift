//
//  CustomizableMenu.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 18.06.2023.
//

import UIKit

class CustomizableMenu: UIView {
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .red
        return stackView
    }()
    
    // MARK: - Lifecycle methods
    init(bgColor: UIColor) {
//        self.colors = colors.map({ $0.cgColor })
//        self.startPoint = startPoint
//        self.endPoint = endPoint
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
//        colors = [UIColor.clear.cgColor]
//        startPoint = .zero
//        endPoint = .zero
        
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Setup views
    func setupView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
