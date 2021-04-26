//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 16.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

final class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    let cellReuseID = String(describing: PhotoCell.self)
    let cellNib = UINib(nibName: String(describing: PhotoCell.self), bundle: nil)
    let numberOfItemsPerRow = 3
    var user: User?
    var posts: [Post]?
    var followed: [User]?
    
    var isFollowed: Bool {
        let users = followed?.filter { $0.id == AppSettings.shared.currentUser?.id }
        return users?.count != 0
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (user == nil) {
            user = AppSettings.shared.currentUser
        }
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        setupNavigationBar()
    }
    
    private func getUserData() {
        if !NetworkManager.shared.isOffline {
            loadUserData()
        } else {
            if let userData = CoreDataManager.shared.fetchData(for: CUser.self).first {
                self.user = User(user: userData)
                self.posts = CoreDataManager.shared.fetchUserPosts(userId: self.user?.id ?? "").map {
                    Post(post: $0)
                }
            }
        }
    }
    
    private func loadUserData() {
        if let user = user {
            self.showActivityIndicator()
            let initialDataGroup = DispatchGroup()
            initialDataGroup.enter()
            self.getCurrentUser { [weak self] user in
                initialDataGroup.leave()
                guard let self = self else { return }
                self.user = user
            }
            initialDataGroup.enter()
            self.fetchUserPosts(user: user, completion: { [weak self] posts in
                initialDataGroup.leave()
                guard let self = self else { return }
                self.posts = posts
                if let posts = posts,
                   user.id == AppSettings.shared.currentUser?.id {
                    CoreDataManager.shared.savePostsToStorage(posts: posts)
                }
            })
            initialDataGroup.enter()
            self.fetchFollowedUsers(userId: user.id, completion: { [weak self] users in
                initialDataGroup.leave()
                guard let self = self else { return }
                self.followed = users
            })
            initialDataGroup.notify(queue: DispatchQueue.main, execute: { [weak self] in
                 guard let self = self else { return }
                 self.hideActivityIndicator()
                 self.profileCollectionView.reloadData()
            })
        }
    }
    
    // MARK: setup
    
    private func setupViews() {
        profileCollectionView.register(self.cellNib,
        forCellWithReuseIdentifier: self.cellReuseID)
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = user?.username
        if let user = user,
           user.id == AppSettings.shared.currentUser?.id {
           self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
        }
    }
    
    // MARK: UI Actions
    @objc func logOut() {
        if !NetworkManager.shared.isOffline {
            NetworkManager.shared.logoutRequest(success: {
                DispatchQueue.main.async {
                    NetworkManager.shared.logout()
                    NavigationManager.shared.setupLoginViewControllerAsRoot()
                }
            },
            errorHandler: { [weak self] error in
                guard let _self = self else { return }
                DispatchQueue.main.async {
                    NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                }
            })
        } else {
            DispatchQueue.main.async {
                NetworkManager.shared.logout()
                NavigationManager.shared.setupLoginViewControllerAsRoot()
            }
        }
    }
    
}

extension ProfileViewController: UICollectionViewDataSource,
                                 UICollectionViewDelegate,
                                 UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseID, for: indexPath) as? PhotoCell else {
            fatalError("Wrong cell")
        }
        if let posts = posts {
            cell.configure(image: posts[indexPath.row].image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                layout collectionViewLayout: UICollectionViewLayout,
                sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
      switch kind {
          case UICollectionView.elementKindSectionHeader:
              guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                  withReuseIdentifier: String(describing: ProfileHeaderView.self),
                  for: indexPath) as? ProfileHeaderView else {
                  fatalError("Invalid view type")
              }
              headerView.followButton.isHidden = (user?.id == AppSettings.shared.currentUser?.id) || followed == nil
              headerView.usernameLabel.text = user?.fullName
              headerView.followersLabel.text = "Followers: \(user?.followedByCount ?? 0)"
              headerView.followingLabel.text = "Following: \(user?.followsCount ?? 0)"
              headerView.profileImageView.kf.setImage(with: URL(string: user?.avatar ?? ""))
              headerView.setUser(user: user)
              headerView.delegate = self
              headerView.followButton.setTitle(self.isFollowed ? "Unfollow" : "Follow", for: .normal)
              UIView.performWithoutAnimation({
                  headerView.followButton.setTitle(self.isFollowed ? "Unfollow" : "Follow", for: .normal)
                  headerView.followButton.layoutIfNeeded()
              })
              
              return headerView
         default:
             assert(false, "Invalid element type")
      }
    }
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    
    func didFollowersTap(userId: String) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        let usersController = NavigationManager.shared.getUsersViewController()
        guard user?.followsCount != 0 else { return }
        self.showActivityIndicator()
        self.fetchFollowedUsers(userId: userId, completion: { [weak self] followers in
            guard let self = self else { return }
            guard let followers = followers else { return }
            if followers.count > 0 {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    usersController.users = followers
                    usersController.title = "Followers"
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
        guard user?.followedByCount != 0 else { return }
        self.showActivityIndicator()
        self.fetchFollowingUsers(userId: userId, completion: { [weak self] following in
            guard let self = self else { return }
            guard let following = following else { return }
            if following.count > 0 {
                DispatchQueue.main.async {
                   self.hideActivityIndicator()
                   usersController.users = following
                   usersController.title = "Following"
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

// MARK: API methods
private extension ProfileViewController {
    
    func getCurrentUser(completion: @escaping (User?) -> Void) {
        if let user = user {
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



