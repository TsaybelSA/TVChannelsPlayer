//
//  ChannelDescriptionView.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 17.06.2023.
//

import UIKit

class ChannelDescriptionView: UIView {
    
    // MARK: - Properties
    var channel: Channel = .mock {
        didSet { updateInfo() }
    }
    
    var channelImage: UIImage? {
        didSet {
            DispatchQueue.main.async { [self] in                
                channelImageView.image = channelImage
            }
        }
    }
    
    // MARK: - Views

    private var channelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [channelTitle, currentProgrammTitle])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let channelTitle: UILabel = {
        let label = UILabel()
        label.text = "channelTitle"
        label.font = .roboto.bold(18)
        label.textColor = .white
        return label
    }()
    
    private let currentProgrammTitle: UILabel = {
        let label = UILabel()
        label.text = "currnetProgrammTitle"
        label.font = .roboto.regular(15)
        label.textColor = #colorLiteral(red: 0.9309120178, green: 0.934602797, blue: 0.9500084519, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSide = frame.height
        channelImageView.frame = CGRect(x: 10, y: 0,
                                    width: imageSide,
                                    height: imageSide)
        
        let stackViewOriginX = 20 + channelImageView.frame.maxX
        stackView.frame = CGRect(x: stackViewOriginX, y: 0,
                                 width: frame.width - stackViewOriginX,
                                 height: imageSide)
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(channelImageView)
        addSubview(stackView)
    }
    
    // MARK: - Setup Views

    private func updateInfo() {
        DispatchQueue.executeOnMain { [self] in
            channelTitle.text = channel.nameRu
            currentProgrammTitle.text = channel.current.title
        }
    }
}
