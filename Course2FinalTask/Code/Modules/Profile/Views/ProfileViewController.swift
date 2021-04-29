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
    var dataSource: ProfileDataSource = ProfileDataSource()
    
    var isFollowed: Bool {
        let users = dataSource.followed?.filter { $0.id == AppSettings.shared.currentUser?.id }
        return users?.count != 0
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (dataSource.user == nil) {
            dataSource.user = AppSettings.shared.currentUser
        }
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        setupNavigationBar()
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

private extension ProfileViewController {
    
    // MARK: setup
    
    func setupViews() {
        profileCollectionView.register(self.cellNib,
        forCellWithReuseIdentifier: self.cellReuseID)
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = dataSource.user?.username
        if let user = dataSource.user,
           user.id == AppSettings.shared.currentUser?.id {
           self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("logOutButton.text", comment: "Text for logout button."), style: .plain, target: self, action: #selector(logOut))
        }
    }
    
}
