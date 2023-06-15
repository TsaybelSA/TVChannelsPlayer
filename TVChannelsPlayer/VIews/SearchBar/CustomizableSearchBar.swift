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

class CustomSearchController: UISearchController {
    lazy var customizableSearchBar: UISearchBar = CustomizableSearchBar()
    
    override var searchBar: UISearchBar { customizableSearchBar }
}

protocol CustomSearchBarDelegate: AnyObject {
    func didChangeSearchText(searchText: String)
}

class CustomSearchBar: UIView {
    @IBInspectable var leftOffset: CGFloat = .zero
    @IBInspectable var rightOffset: CGFloat = .zero
    @IBInspectable var textFieldTrailingInset: CGFloat = 10
    @IBInspectable var textColor: UIColor = .black {
        didSet { updateTextFieldAppearance() }
    }

    @IBInspectable var placeholder: String = "Напишите название телеканала" {
        didSet { updateTextFieldAppearance() }
    }

    @IBInspectable var innerColor: UIColor {
        get { containerView.backgroundColor ?? .clear }
        set { containerView.backgroundColor = newValue }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get { containerView.layer.cornerRadius }
        set { containerView.layer.cornerRadius = newValue }
    }
    
    weak var delegate: CustomSearchBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        attachViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        attachViews()
    }

    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var searchBarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchBarIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchIconPressed))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        setFrame()
    }

    private func setFrame() {
        let searchIconSide = frame.height * 0.38
        containerView.frame = self.bounds
        searchBarIcon.frame = CGRect(x: leftOffset, y: (frame.height - searchIconSide) / 2,
                                     width: searchIconSide, height: searchIconSide)

        let textFieldWidth = bounds.width - (leftOffset + searchIconSide + textFieldTrailingInset + rightOffset)
        textField.frame = CGRect(x: Int(searchBarIcon.frame.maxX) + 10, y: 0,
                                 width: Int(textFieldWidth),
                                 height: Int(frame.height))
    }

    private func attachViews() {
        addSubview(containerView)
        addSubview(searchBarIcon)
        addSubview(textField)
    }

    private func updateTextFieldAppearance() {
        textField.textColor = textColor
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: textColor]
        )
    }

    // MARK: - Actions
    @objc
    private func searchIconPressed() {
        textField.becomeFirstResponder()
    }
}


extension CustomSearchBar: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        delegate?.didChangeSearchText(searchText: string)
        return true
    }
}

