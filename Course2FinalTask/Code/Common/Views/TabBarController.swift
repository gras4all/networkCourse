//
//  TabBarController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 16.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.

import UIKit

final class TabBarController: UITabBarController {

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewDidLoad() {
        viewControllers?[0].tabBarItem.title = NSLocalizedString("tabFeed.title", comment: "Text for feed tab.")
        viewControllers?[1].tabBarItem.title = NSLocalizedString("tabNew.title", comment: "Text for new post tab.")
        viewControllers?[2].tabBarItem.title = NSLocalizedString("tabProfile.title", comment: "Text for profile tab.")
    }
    
}


