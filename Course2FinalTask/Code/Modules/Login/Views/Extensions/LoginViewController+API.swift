//
//  LoginViewController+API.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 29.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

extension LoginViewController {
    
    func sendCurrentUserRequest() {
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
    
    func sendPostsCurrentUserRequest(currentUserId: String) {
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
    
}
