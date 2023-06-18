//
//  CustomizableMenu.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 18.06.2023.
//

import UIKit

class CustomizableMenu: UIView {
    
    private let titles: [String]
    private var bgColor: UIColor?
    private var textColor: UIColor?
    
    var buttonActionHandler: ((String?) -> Void)?
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle methods
    init(buttonTitles: [String],
         bgColor: UIColor? = .gray,
         textColor: UIColor? = Colors.secondaryBackgroundColor?.withAlphaComponent(0.9)) {
        self.titles = buttonTitles
        self.bgColor = bgColor
        self.textColor = textColor
        
        super.init(frame: .zero)
        backgroundColor = bgColor
        setupView()
    }
    
    required init?(coder: NSCoder) {
        titles = []
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Setup views
    private func setupView() {
        backgroundColor = .clear
        
        setupStackView()
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        stackView.backgroundColor = bgColor
        stackView.subviews.forEach({ $0.removeFromSuperview() })
        
        for title in titles {
            let button = UIButton(type: .system)
            button.titleLabel?.font = .roboto.regular(16)
            button.backgroundColor = .white
            button.titleLabel?.textColor = .black
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    // MARK: - Actions
    @objc
    private func buttonAction(_ sender: UIButton) {
        buttonActionHandler?(sender.currentTitle)
    }
}
