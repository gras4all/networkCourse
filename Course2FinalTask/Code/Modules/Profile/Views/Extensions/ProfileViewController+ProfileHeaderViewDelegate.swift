//
//  ProfileViewController+ProfileHeaderViewDelegate.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func didFollowersTap(userId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        let usersController = NavigationManager.shared.getUsersViewController()
        guard dataSource.user?.followsCount != 0 else { return }
        self.showActivityIndicator()
        self.fetchFollowedUsers(userId: userId, completion: { [weak self] followers in
            guard let self = self else { return }
            guard let followers = followers else { return }
            if followers.count > 0 {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    usersController.users = followers
                    usersController.title = NSLocalizedString("followersScreen.title", comment: "Title for followers screen.")
                        self.navigationController?.pushViewController(usersController, animated: true)
                }
            }
        })
    }
    
    func didFollowingTap(userId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        let usersController = NavigationManager.shared.getUsersViewController()
        guard dataSource.user?.followedByCount != 0 else { return }
        self.showActivityIndicator()
        self.fetchFollowingUsers(userId: userId, completion: { [weak self] following in
            guard let self = self else { return }
            guard let following = following else { return }
            if following.count > 0 {
                DispatchQueue.main.async {
                   self.hideActivityIndicator()
                   usersController.users = following
                   usersController.title = NSLocalizedString("followingScreen.title", comment: "Title for following screen.")
                       self.navigationController?.pushViewController(usersController, animated: true)
                }
            }
        })
    }
    
    func didFollowBtnTap(userId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        if self.isFollowed {
            self.unfollow(userId: userId, completion: { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.getUserData()
                }
            })
        } else {
            self.follow(userId: userId, completion: { [weak self] user in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.getUserData()
                }
            })
        }
    }
    
}


