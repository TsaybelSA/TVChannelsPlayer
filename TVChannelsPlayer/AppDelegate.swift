//
//  AppDelegate.swift
//  TVChannelsPlayer
//
//  Created by Сергей Цайбель on 10.06.2023.
//

import UIKit

var isOnlyLandscape = false

@main
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
            return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

               if !isOnlyLandscape {
                    return UIInterfaceOrientationMask.all
               } else {
                   return UIInterfaceOrientationMask.landscape
               }
       }
}

