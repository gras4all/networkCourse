//
//  ProfileViewController+API.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

// MARK: API methods
extension ProfileViewController {
    
    func getUserData() {
        if !NetworkManager.shared.isOffline {
            loadUserData()
        } else {
            if let userData = CoreDataManager.shared.fetchData(for: CUser.self).first {
                self.dataSource.user = User(user: userData)
                self.dataSource.posts = CoreDataManager.shared.fetchUserPosts(userId: self.dataSource.user?.id ?? "").map {
                    Post(post: $0)
                }
            }
        }
    }
    
    func loadUserData() {
        if let user = dataSource.user {
            self.showActivityIndicator()
            let initialDataGroup = DispatchGroup()
            initialDataGroup.enter()
            self.getCurrentUser { [weak self] user in
                initialDataGroup.leave()
                guard let self = self else { return }
                self.dataSource.user = user
            }
            initialDataGroup.enter()
            self.fetchUserPosts(user: user, completion: { [weak self] posts in
                initialDataGroup.leave()
                guard let self = self else { return }
                self.dataSource.posts = posts
                if let posts = posts,
                   user.id == AppSettings.shared.currentUser?.id {
                    CoreDataManager.shared.savePostsToStorage(posts: posts)
                }
            })
            initialDataGroup.enter()
            self.fetchFollowedUsers(userId: user.id, completion: { [weak self] users in
                initialDataGroup.leave()
                guard let self = self else { return }
                self.dataSource.followed = users
            })
            initialDataGroup.notify(queue: DispatchQueue.main, execute: { [weak self] in
                 guard let self = self else { return }
                 self.hideActivityIndicator()
                 self.profileCollectionView.reloadData()
            })
        }
    }
    
    func getCurrentUser(completion: @escaping (User?) -> Void) {
        if let user = dataSource.user {
            NetworkManager.shared.getUser(userId: user.id, success: completion, errorHandler: { [weak self] error in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    _self.hideActivityIndicator(completion: { [weak self] in
                     guard let _self = self else { return }
                     NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                     })
                }
            })
        }
    }
    
    func fetchUserPosts(user: User, completion: @escaping ([Post]?) -> Void) {
        NetworkManager.shared.getPostsUserRequest(userId: user.id, success: completion, errorHandler: { [weak self] error in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.hideActivityIndicator(completion: { [weak self] in
                 guard let _self = self else { return }
                 NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                 })
            }
        })
    }
    
    func fetchFollowedUsers(userId: String/*User.Identifier*/, completion: @escaping ([User]?) -> Void) {
        NetworkManager.shared.getFollowedUsers(userId: userId, success: completion, errorHandler: { [weak self] error in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.hideActivityIndicator(completion: { [weak self] in
                 guard let _self = self else { return }
                 NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                 })
            }
        })
    }
    
    func fetchFollowingUsers(userId: String, completion: @escaping ([User]?) -> Void) {
        NetworkManager.shared.getFollowingUsers(userId: userId, success: completion, errorHandler: { [weak self] error in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.hideActivityIndicator(completion: { [weak self] in
                 guard let _self = self else { return }
                 NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                 })
            }
        })
    }
    
    func follow(userId: String, completion: @escaping (User?) -> Void) {
        NetworkManager.shared.followRequest(userId: userId,  success: completion,
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
    
    func unfollow(userId: String, completion: @escaping (User?) -> Void) {
        NetworkManager.shared.unfollowRequest(userId: userId,  success: completion,
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

}



