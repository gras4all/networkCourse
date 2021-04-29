//
//  FeedViewController+API.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 29.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

extension FeedViewController {
    
    func unlikePost(postId: String) {
        NetworkManager.shared.unlikeRequest(postId: postId, success: { [weak self] users in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.updateFeed()
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
    
    func likePost(postId: String) {
        NetworkManager.shared.likeRequest(postId: postId, success: { [weak self] users in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.updateFeed()
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
    
    func sendFeedRequest() {
        NetworkManager.shared.feedRequest(success: { [weak self] posts in
            guard let _self = self else { return }
            _self.posts = posts
            CoreDataManager.shared.savePostsToStorage(posts: posts)
        },
        errorHandler: { [weak self] error in
            guard let _self = self else { return }
            NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
        })
    }
    
}
