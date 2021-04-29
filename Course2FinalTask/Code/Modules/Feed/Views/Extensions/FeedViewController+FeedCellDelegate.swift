//
//  FeedViewController+FeedCellDelegate.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 29.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension FeedViewController: FeedCellDelegate {
    
    func didLikeTap(postId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        guard let currentUserId = AppSettings.shared.currentUser?.id else { return }
        NetworkManager.shared.getUsersLikedThisPost(postId: postId, success: { [weak self] usersLiked in
            guard let _self = self else { return }
            let userIds = usersLiked.map { $0.id }
            if userIds.contains(currentUserId) {
                _self.unlikePost(postId: postId)
            } else {
                _self.likePost(postId: postId)
            }
        },
        errorHandler: { [weak self] error in
            guard let _self = self else { return }
            NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
        })
    }
    
    func didPostImageTap(postId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        self.likePost(postId: postId)
    }
    
    func didShowProfile(authorId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        self.showActivityIndicator()
        NetworkManager.shared.getUser(userId: authorId, success: { [weak self] author in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                let profileViewController = NavigationManager.shared.getProfileViewController()
                profileViewController.dataSource.user = author
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }, errorHandler: { error in
            
        })
    }
    
    func didLikesTap(postId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        self.showActivityIndicator()
        NetworkManager.shared.getUsersLikedThisPost(postId: postId, success: { [weak self] users in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.hideActivityIndicator()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let usersController = storyboard.instantiateViewController(withIdentifier: String(describing: UsersViewController.self)) as! UsersViewController
                usersController.users = users
                usersController.title = NSLocalizedString("likesScreen.title", comment: "Title for likes screen.")
                _self.navigationController?.pushViewController(usersController, animated: true)
            }
        },
        errorHandler: { [weak self] error in
            guard let _self = self else { return }
            _self.hideActivityIndicator()
        })
    }
}
