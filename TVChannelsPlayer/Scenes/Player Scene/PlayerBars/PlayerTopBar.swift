//
//  PlayerTopBar.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 17.06.2023.
//

import UIKit

class PlayerTopBar: GradientBar {
    // MARK: - Properties
    
    var backButtonAction: (() -> Void)?
    
    // MARK: - Views
    var channelDescriptionView: ChannelDescriptionView = {
        let view = ChannelDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backImageButton: UIButton = {
       let button = UIButton()
        button.setBackgroundImage(UIImage(named: "backArrow"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle methods
    override init(colors: [UIColor],
                  startPoint: CGPoint = .init(x: 0.5, y: 0.0),
                  endPoint: CGPoint = .init(x: 0.5, y: 1.0)) {
        super.init(colors: colors)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        addSubview(backImageButton)
        addSubview(channelDescriptionView)
    }
    
    override func updateViewsFrames() {
        
        let imageSide = 20
        backImageButton.frame = CGRect(x: 20, y: (Int(frame.height) - imageSide) / 2,
                                    width: imageSide,
                                    height: imageSide)
        
        let descriptionViewOffset = 20
        let channelDescriptionViewOriginX = 20 + imageSide
        channelDescriptionView.frame = CGRect(x: channelDescriptionViewOriginX + 20,
                                              y: descriptionViewOffset / 2,
                                              width: Int(frame.width) - channelDescriptionViewOriginX,
                                              height: Int(frame.height) - descriptionViewOffset)
    }
    
    // MARK: - Actions
    
    @objc
    private func backButtonTapped() {
        backButtonAction?()
    }
}

