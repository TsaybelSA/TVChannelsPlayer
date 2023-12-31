//
//  ChannelTableViewCell.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    // MARK: - Views
    @IBOutlet private weak var favouriteButton: UIButton!

    @IBOutlet weak var channelDescriptionView: ChannelDescriptionView!
    
    // MARK: - Properties
    var channel: Channel = .mock {
        didSet { didSetChannel() }
    }
    
    var channelImage: UIImage? {
        didSet {
            channelDescriptionView.channelImage = channelImage
        }
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
                
        updateFavouriteButton()
    }
    
    private func didSetChannel() {
        channelDescriptionView.channel = channel
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
