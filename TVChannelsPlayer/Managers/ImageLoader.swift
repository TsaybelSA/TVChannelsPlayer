//
//  ImageLoader.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import UIKit

enum LoadingError: Error {
    case brokenData
    case failedToLoad(error: String)
    case failedToMakeURL
    case failedToParseData
}

protocol ImageLoaderInterface {
    func getImage(for key: String, complitionHandler: @escaping (UIImage?, String) -> Void) throws
}

struct ImageLoader: InternetLoader {    
    private let _cache = NSCache<NSString, UIImage>()
    
    func loadImageWithUrl(_ url: URL, complitionHandler: @escaping ((UIImage?) -> Void)) {
        getData(from: url) { data, response, error in
            guard let data = data else { return }

            complitionHandler(UIImage(data: data))
        }
    }
}

extension ImageLoader: LoaderFromCache, ImageLoaderInterface {
    var cache: NSCache<NSString, UIImage> { _cache }
    
    func getImage(for key: String, complitionHandler: @escaping (T?, String) -> Void) throws {
       try getObjectFor(key: key, complitionHandler: complitionHandler)
    }
    
    func loadingHandler(with urlString: String, complitionHandler: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        loadImageWithUrl(url) { image in
            complitionHandler(image)
        }
    }
}
