//
//  Channel.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 13.06.2023.
//

import Foundation

struct Channel: Codable {
    let id: Int
    let epg_id: Int
    let name_ru: String
    let name_en: String
    let vitrina_events_url: String
    let isFederal: Bool
    let address: String
    let image: String
    let hasEpg: Bool
    let current: CurrentProgram
    let region_code: Int
    let tz: Int
    let is_foreign: Bool
    let number: Int
    let drm_status: Int
    let owner: String
    let foreign_player: ForeignPlayer
    let foreign_player_key: Bool
    let url: String
    let url_sound: String
    let cdn: String
    
    struct CurrentProgram: Codable {
        let timestart: Int
        let timestop: Int
        let title: String
        let desc: String
        let cdnvideo: Int
        let rating: Int
    }

    struct ForeignPlayer: Codable {
        let sdk: String
        let url: String
        let valid_from: Int
    }
    
    static let mock = Channel(id: 0, epg_id: 0, name_ru: "Канал для теста", name_en: "Mock Channel",
                              vitrina_events_url: "", isFederal: true, address: "",
                              image: "https://assets.iptv2022.com/static/channel/105/logo_256_1655386697.png",
                              hasEpg: true, current: CurrentProgram(timestart: 0, timestop: 0, title: "Program",
                                                                    desc: "", cdnvideo: 0, rating: 16),
                              region_code: 0, tz: 0, is_foreign: false, number: 0, drm_status: 0, owner: "lime",
                              foreign_player: ForeignPlayer(sdk: "", url: "", valid_from: 0),
                              foreign_player_key: false, url: "", url_sound: "", cdn: "")
}


