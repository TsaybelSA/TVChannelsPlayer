//
//  DispatchQueueExtension.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 17.06.2023.
//

import Foundation

extension DispatchQueue {
    static func executeOnMain(complitionHandler: @escaping () -> Void) {
        if Thread.isMainThread {
            complitionHandler()
        } else {
            DispatchQueue.main.async {
                complitionHandler()
            }
        }
    }
}
