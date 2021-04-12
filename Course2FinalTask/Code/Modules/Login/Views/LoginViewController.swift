//
//  LoginViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 03.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleToken()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func tapSignIn(_ sender: Any) {
        showActivityIndicator()
        NetworkManager.shared.loginRequest(username: usernameField.text ?? "",
                                           password: passwordField.text ?? "",
                                           success: { [weak self] in
                                               guard let _self = self else { return }
                                               _self.sendCurrentUserRequest()
                                           },
                                           errorHandler: { [weak self] error in
                                               guard let _self = self else { return }
                                               DispatchQueue.main.async {
                                                   _self.hideActivityIndicator(completion: { [weak self] in
                                                    guard let _self = self else { return }
                                                    NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                                               })
                                            }
                                           })
    }
    
    private func sendCurrentUserRequest() {
        NetworkManager.shared.getCurrentUser(success: { [weak self] user in
            guard let _self = self else { return }
            AppSettings.shared.currentUser = user
            DispatchQueue.main.async {
                _self.hideActivityIndicator(completion: {
                    guard let nc = _self.navigationController else { return }
                    NavigationManager.shared.setupTabBarViewControllerAsRoot(nc: nc)
                })
            }
            DispatchQueue.global(qos: .background).async {
                CoreDataManager.shared.saveUsersToStorage(users: [user])
            }
        },
        errorHandler: { [weak self] error in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.hideActivityIndicator(completion: { [weak self] in
                    guard let _self = self else { return }
                    NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                })
            }
        })
    }
    
    private func sendPostsCurrentUserRequest(currentUserId: String) {
        NetworkManager.shared.getPostsUserRequest(userId: currentUserId, success: { posts in
            DispatchQueue.global(qos: .background).async {
                CoreDataManager.shared.savePostsToStorage(posts: posts)
            }
        }, errorHandler: { [weak self] error in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
            }
        })
    }
    
    private func handleToken() {
        if let receivedData = KeyChain.load(key: KeyChain.kToken) {
            let token = String(decoding: receivedData, as: UTF8.self)
            showActivityIndicator()
            NetworkManager.shared.checkToken(token: token, success: { [weak self] in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    _self.hideActivityIndicator(completion: { [weak self] in
                        guard let _self = self else { return }
                        // авторизация
                        _self.sendCurrentUserRequest()
                    })
                }
            },
            errorHandler: { [weak self] error in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    _self.hideActivityIndicator(completion: { [weak self] in
                        guard let _self = self else { return }
                        if error != 401 {
                            // в оффлайн
                            print("======> Go offline")
                            NetworkManager.shared.isOffline = true
                            if let currentUser = CoreDataManager.shared.fetchCurrentUser() {
                                AppSettings.shared.currentUser = User(user: currentUser)
                            }
                            guard let nc = _self.navigationController else { return }
                            NavigationManager.shared.setupTabBarViewControllerAsRoot(nc: nc)
                        } else {
                            // invalid token
                            print("======> Invalid token")
                        }
                    })
                }
            })
        }
    }
    
}


