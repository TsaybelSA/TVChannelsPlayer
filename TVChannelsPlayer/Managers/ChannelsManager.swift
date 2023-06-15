//
//  ChannelsManager.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import Foundation

extension Notification.Name {
    static let channelsLoaded = Notification.Name("channelsLoaded")
}

protocol ChannelsUpdateListener: NSObject {
    /// Invokes when channels if loaded
    func channelsUpdated()
}

extension ChannelsUpdateListener {
    /// Call this method to start listen changes of .
    func startListenChannelsUpdate() {
        NotificationCenter.default.addObserver(forName: .channelsLoaded,
                                               object: nil, queue: .main) { [weak self] _ in
            self?.channelsUpdated()
        }
    }
}

protocol ChannelsManagerInterface {
    var channels: [Channel] { get }
}

class ChannelsManager: ChannelsManagerInterface {
    private init() {
        channelsLoader = ChannelsLoader()
        
        startDataLoading()
    }
    static let shared = ChannelsManager()
    
    private let channelsLoader: ChannelsLoaderInterface
    
    private(set) var channels: [Channel] = []
    
    private func startDataLoading() {
        DispatchQueue.global(qos: .background).async {
            self.channelsLoader.getChannels { channels in
                if channels.isEmpty {
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                        self.startDataLoading()
                    }
                } else {
                    self.channels = channels
                    NotificationCenter.default.post(name: .channelsLoaded, object: nil)
                }
            }
        }
    }
}
