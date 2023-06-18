//
//  GradientBar.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 18.06.2023.
//

import UIKit

class GradientBar: UIView {
    // MARK: - Properties
    private let colors: [CGColor]
    private let startPoint: CGPoint
    private let endPoint: CGPoint
    
    // MARK: - Views
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.frame = frame
        return gradient
    }()
    
    // MARK: - Lifecycle methods
    init(colors: [UIColor],
         startPoint: CGPoint = .init(x: 0.5, y: 0.0),
         endPoint: CGPoint = .init(x: 0.5, y: 1.0)) {
        self.colors = colors.map({ $0.cgColor })
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        colors = [UIColor.clear.cgColor]
        startPoint = .zero
        endPoint = .zero
        
        super.init(coder: coder)
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateGradientFrame()
        updateViewsFrames()
    }
    
    // MARK: - Setup views
    func setupView() {
        gradientLayer.colors = colors
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientFrame() {
        gradientLayer.frame = self.bounds
    }
    
    func updateViewsFrames() {}
}
