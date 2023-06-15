//
//  ChannelTableViewCell.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet private weak var channelImageView: UIImageView!
    @IBOutlet private weak var channelTitle: UILabel!
    @IBOutlet private weak var programTitle: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!

    // MARK: - Properties
    var channel: Channel = .mock {
        didSet { updateInfo() }
    }
    
    var favouriteTapHandler: ((Channel, Bool) -> ())?

    var isFavourite: Bool = false {
        didSet {
            updateFavouriteButton()
        }
    }
    
    // MARK: - Lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.backgroundColor = Colors.mainBackgroundColor
        contentView.layer.cornerRadius = 10
        
        channelImageView.layer.cornerRadius = 4
        
        updateFavouriteButton()
        updateInfo()
    }
    
    private func updateInfo() {
        channelTitle.text = isRuLocale ? channel.name_ru : channel.name_en
        programTitle.text = channel.current.title
    }

    func updateFavouriteButton() {
        let image = UIImage(named: isFavourite ? "star.active" : "star.inactive")
        favouriteButton.setBackgroundImage(image, for: .normal)
    }

    // MARK: - Actions
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        favouriteTapHandler?(channel, !isFavourite)
    }
}
