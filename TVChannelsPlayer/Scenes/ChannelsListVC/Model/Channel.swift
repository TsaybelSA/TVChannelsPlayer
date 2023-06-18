//
//  Channel.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import Foundation

struct ChannelsListResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case channels
    }
    
    let channels: [Channel]
}

struct Channel: Codable {
    let id: Int
    let nameRu: String
    let image: String
    let current: CurrentProgram
    
    struct CurrentProgram: Codable {
        let title: String
    }
    
    static let mock = Channel(id: 0, nameRu: "Канал для теста",
                              image: "https://assets.iptv2022.com/static/channel/105/logo_256_1655386697.png",
                              current: CurrentProgram(title: "Любая программа"))
}


