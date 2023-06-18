//
//  InternetLoader.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import Foundation

protocol InternetLoader {}

extension InternetLoader {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared
            .dataTask(with: url, completionHandler: completion)
            .resume()
    }
    
    @available(iOS 15.0, *)
    func asyncGetData(from url: URL) async throws -> Data {
        let (data,_ ) = try await URLSession.shared.data(from: url)
        return data
    }
}
