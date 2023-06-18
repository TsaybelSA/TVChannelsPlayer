//
//  CacheLoader.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 15.06.2023.
//

import UIKit

protocol LoaderFromCache {
    associatedtype T: AnyObject
    var cache: NSCache<NSString, T> { get }
    
    func loadingHandler(with url: String, complitionHandler: @escaping (T?) -> Void) throws
}

extension LoaderFromCache {
    func getObjectFor(key: String, complitionHandler: @escaping (T?, String) -> Void) throws {
        let keyNSString = key as NSString
        if let cachedObject = cache.object(forKey: keyNSString) {
            complitionHandler(cachedObject, key)
        } else {
            try loadingHandler(with: key) { object in
                if let object = object {
                    cache.setObject(object, forKey: keyNSString)
                }
                complitionHandler(object, key)
            }
        }
    }
}
