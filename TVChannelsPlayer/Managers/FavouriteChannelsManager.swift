//
//  FavouriteChannelsManager.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import UIKit

extension Notification.Name {
    static let channelFavouriteStateChanged = Notification.Name("channelFavouriteStateChanged")
}

protocol FavouriteStateListener: NSObject {
    /// Invokes when favourite state of any channel changes
    func updateChannelsStatus()
}

extension FavouriteStateListener {
    /// Call this method to start listen changes of favourite state of any channel.
    func startListenFavouriteStatusChanges() {
        NotificationCenter.default.addObserver(forName: .channelFavouriteStateChanged,
                                               object: nil, queue: .main) { [weak self] _ in
            self?.updateChannelsStatus()
        }
    }
}

class FavouriteChannelsInterface {
    /// For checking favourite state of channel.
    /// - Parameter channel: The channel ID for which need to check state in favourites list.
    /// - Returns: Boolean that indicating is 'channel' in favourites list.
    func isInFavourites(_ channelID: Int) -> Bool { false }
    
    /// For set favourite state of channel.
    /// Need to call super method to invoke notification center post method.
    /// - Parameter channelID: The channel ID  for which need to change state .
    /// - Parameter isFavourite: The state in favourites list that need to set for provided 'channel' .
    func setFavouriteState(by channelID: Int, isFavourite: Bool) {
        NotificationCenter.default.post(name: .channelFavouriteStateChanged, object: nil)
    }
}

/*
 В данном случае принято решение использовать UserDefaults хранилище,
 тк предполагается харанение только Set<Int>, размер которого слишком мал,
 чтобы существенно повлиять на общую скорость загрузки приложения.
 
 В последствии, при желании перейти на другую базу данных для хранения списка избранных каналов,
 достаточно будет добавить новую сущность и наследоваться от 'FavouriteChannelsInterface'.
 */

final class FavouriteChannelsManager: FavouriteChannelsInterface {
    private override init() { }
    
    static let shared = FavouriteChannelsManager()
    
    @ThreadSafeNonNilUserDefaultsValue(key: UserDefaults.Keys.favouriteChannels.rawValue,
                                       defaultValue: [])
    var favouriteChannelIDs: Set<Int>
    
    override func isInFavourites(_ channelID: Int) -> Bool {
        favouriteChannelIDs.contains(channelID)
    }
    
    override func setFavouriteState(by channelID: Int, isFavourite: Bool) {
        if isFavourite {
            favouriteChannelIDs.insert(channelID)
        } else {
            favouriteChannelIDs.remove(channelID)
        }

        super.setFavouriteState(by: channelID, isFavourite: isFavourite)
    }
}
