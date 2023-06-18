//
//  CustomizableSearchBar.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 10.06.2023.
//

import UIKit

class CustomizableSearchBar: UISearchBar {
    @IBInspectable var height: CGFloat = 48.0
    @IBInspectable var foregroundColor: UIColor = .black
    @IBInspectable var textFieldBgColor: UIColor = .gray
    @IBInspectable var cancelButtonImage: UIImage? {
        didSet { setImage(cancelButtonImage, for: .clear, state: .normal) }
    }
    @IBInspectable var searchImage: UIImage? {
        didSet { setImage(searchImage, for: .search, state: .normal) }
    }
    var font: UIFont = .systemFont(ofSize: 20)


    override func draw(_ rect: CGRect) {
        if let textfield = value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = textFieldBgColor
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "",
                                                attributes: [.foregroundColor : foregroundColor,
                                                             .font : font])
            textfield.textColor = foregroundColor
            textfield.font = font
            
            textfield.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textfield.heightAnchor.constraint(equalToConstant: height),
                textfield.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                textfield.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                textfield.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = foregroundColor
            }
        }
        
        super.draw(rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
