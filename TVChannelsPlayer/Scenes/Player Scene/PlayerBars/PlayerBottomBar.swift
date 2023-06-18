//
//  PlayerBottomBar.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 18.06.2023.
//

import UIKit

class PlayerBottomBar: GradientBar {
    // MARK: - Properties
    
    var moveToTime: ((Float) -> Void)?
    var settingsButtonAction: (() -> Void)?
    
    // MARK: - Views
    private var timeLeftLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto.regular(14)
        label.textColor = .white
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "settingsIcon"), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLeftLabel, settingsButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [horizontalStackView, sliderView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(didMoveSlider), for: .valueChanged)
        return slider
    }()
    
    // MARK: - Lifecycle methods
    override init(colors: [UIColor],
                  startPoint: CGPoint = .init(x: 0.5, y: 1.0),
                  endPoint: CGPoint = .init(x: 0.5, y: 0.0)) {
        super.init(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup views
    override func setupView() {
        super.setupView()
        
        setupSlider()
        ininitialSetup()
        addSubview(verticalStackView)
        
    }
    
    override func updateViewsFrames() {
        verticalStackView.frame = CGRect(x: 20, y: 10,
                                         width: Int(frame.width) - 40,
                                         height: Int(frame.height) - 30)
    }
    
    private func setupSlider() {
        sliderView.setThumbImage(UIImage(), for: .normal)
        sliderView.maximumTrackTintColor = .white.withAlphaComponent(0.5)
        let gradient = CAGradientLayer()
        let frame = CGRect.init(x: 0, y: 0, width: sliderView.frame.size.width, height: 5)
        gradient.frame = frame
        gradient.colors = [#colorLiteral(red: 0.1647058824, green: 0.5647058824, blue: 0.9882352941, alpha: 1).cgColor, #colorLiteral(red: 0, green: 1, blue: 1, alpha: 1).cgColor]
        gradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        
        UIGraphicsBeginImageContextWithOptions(gradient.frame.size, gradient.isOpaque, 0.0)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return }
        gradient.render(in: currentContext)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            image.resizableImage(withCapInsets: UIEdgeInsets.zero)
            
            sliderView.setMinimumTrackImage(image, for: .normal)
        }
    }
    
    private func ininitialSetup() {
        // тут должна быть настройка таймлайна по данным с сервера
        let currentTime = Float.random(in: 0...1)
        setCurrentTime(currentTime)
    }
    
    // public interface method
    func setCurrentTime(_ time: Float) {
        sliderView.setValue(time, animated: false)
    }
    
    func setMinutesLeftValue(_ timeLeft: Int) {
        guard timeLeft >= 0 else { return }
        
        var title = String(format: "kTimeLeft".localized, "\(timeLeft)")
        if NSLocale.preferredLanguages.first?.split(separator: "-").first == "ru" {
            let minuteKey: String
            switch timeLeft % 10 {
            case 1: minuteKey = timeLeft < 20 && timeLeft > 1 ? "минут" : "минута"
            case 2...4: minuteKey = timeLeft < 20 && timeLeft > 10 ? "минут" : "минуты"
            default: minuteKey = "минут"
            }
            title += " \(minuteKey)"
        }
        timeLeftLabel.text = title
    }
    
    // MARK: - Actions
    
    @objc
    private func didMoveSlider(_ sender: UISlider) {
        moveToTime?(sender.value)
    }
    
    @objc
    private func settingsButtonTapped() {
        settingsButtonAction?()
    }
}


