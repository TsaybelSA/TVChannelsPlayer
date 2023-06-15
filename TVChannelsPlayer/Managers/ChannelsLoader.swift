//
//  ChannelsLoader.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import Foundation

protocol ChannelsLoaderInterface {
    func getChannels(complitionHandler: @escaping ([Channel]) -> Void)
}

class ChannelsLoader: InternetLoader, ChannelsLoaderInterface {
    private let apiURLString = "http://limehd.online/playlist/channels.json"
        
    func getChannels(complitionHandler: @escaping ([Channel]) -> Void) {
        guard let url = URL(string: apiURLString) else { return }
        getData(from: url) { data, response, error in
            do {
                if let error = error {
                    print(error.localizedDescription)
                    complitionHandler([])
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                guard let data = data else { return }
                
                let decodedData = try decoder.decode(ChannelsListResponse.self, from: data)
                
                complitionHandler(decodedData.channels)
            } catch {
                print(error)
                complitionHandler([])
            }
        }
    }
}
