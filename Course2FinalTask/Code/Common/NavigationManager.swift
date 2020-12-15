//
//  NavigationManager.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 23.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class NavigationManager {
    
    static var shared: NavigationManager = NavigationManager()
    
    var navigationController: UINavigationController?
    
    func getTabBarController() -> TabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: TabBarController.self)) as! TabBarController
    }
    
    func getUsersViewController() -> UsersViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: UsersViewController.self)) as! UsersViewController
    }
    
    func getProfileViewController() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
    }
    
    func getFeedViewController() -> FeedViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: FeedViewController.self)) as! FeedViewController
    }
    
    func getLoginViewController() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
    }
    
    func setupTabBarViewControllerAsRoot(nc: UINavigationController) {
        navigationController = nc
        nc.viewControllers = [getTabBarController()]
    }
    
    func setupLoginViewControllerAsRoot() {
        if let nc = navigationController {
            nc.viewControllers = [getLoginViewController()]
        }
    }
    
    func presentErrorAlert(statusCode: Int, vc: UIViewController) {
        var message = ""
        switch statusCode {
        case 200:
            return
        case 404:
            message = "Not found"
        case 400:
            message = "Bad request"
        case 401:
            message = "Unauthorized"
        case 406:
            message = "Not acceptable"
        case 422:
            message = "Unprocessable"
        default:
            message = "Transfer error"
        }
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
