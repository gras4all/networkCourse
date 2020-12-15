//
//  AppDelegate.swift
//  Course2FinalTask
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /*DataProviders.shared.usersDataProvider.currentUser(queue: DispatchQueue.global(qos: .utility), handler: { user in
            AppSettings.shared.currentUser = user
        })*/
        
        return true
    }
    
}
