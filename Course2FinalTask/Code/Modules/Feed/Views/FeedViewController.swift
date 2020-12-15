//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 16.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FeedViewController: BaseViewController {
    
    @IBOutlet weak var feedTable: UITableView!
    
    var posts: [Post] = [] {
        didSet {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.feedTable.reloadData()
            }
        }
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
        _setupInitialValues()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _setupNavigationBar()
    }
    
    // MARK: setup
    
    private func _setupViews() {
        self.feedTable.delegate = self
        self.feedTable.dataSource = self
    }
    
    private func _setupNavigationBar() {
        self.navigationItem.title = "Feed"
    }
    
    private func _setupInitialValues() {
        self.hideActivityIndicator()
        self.showActivityIndicator()
        sendFeedRequest()
    }
    
    private func sendFeedRequest() {
        NetworkManager.shared.feedRequest(success: { [weak self] posts in
            guard let _self = self else { return }
            _self.posts = posts
        },
        errorHandler: { [weak self] error in
            guard let _self = self else { return }
            NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
        })
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = feedTable.dequeueReusableCell(withIdentifier: String(describing: FeedCell.self)) as! FeedCell
         cell.setPost(post: posts[indexPath.row])
         cell.delegate = self
         return cell
     }

}

// MARK: FeedCellDelegate

extension FeedViewController: FeedCellDelegate {
    
    func didLikeTap(postId: String) {
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
        self.likePost(postId: postId)
    }
    
    func didShowProfile(authorId: String) {
        self.showActivityIndicator()
        NetworkManager.shared.getUser(userId: authorId, success: { [weak self] author in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                let profileViewController = NavigationManager.shared.getProfileViewController()
                profileViewController.user = author
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
        }, errorHandler: { error in
            
        })
    }
    
    func didLikesTap(postId: String) {
        self.showActivityIndicator()
        NetworkManager.shared.getUsersLikedThisPost(postId: postId, success: { [weak self] users in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                _self.hideActivityIndicator()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let usersController = storyboard.instantiateViewController(withIdentifier: String(describing: UsersViewController.self)) as! UsersViewController
                usersController.users = users
                usersController.title = "Likes"
                _self.navigationController?.pushViewController(usersController, animated: true)
            }
        },
        errorHandler: { [weak self] error in
            guard let _self = self else { return }
            _self.hideActivityIndicator()
        })
    }
}


// MARK: API methods
extension FeedViewController {
    
    func updateFeed() {
        sendFeedRequest()
    }
    
    private func unlikePost(postId: String) {
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
    
    private func likePost(postId: String) {
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
    
}
