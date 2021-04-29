//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 16.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FeedViewController: BaseViewController {
    
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
        setupViews()
        setupInitialValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func updateFeed() {
        if !NetworkManager.shared.isOffline {
            sendFeedRequest()
        } else {
            self.hideActivityIndicator()
            self.posts = CoreDataManager.shared.fetchData(for: CPost.self).map {
                Post(post: $0)
            }
        }
    }
    
}

private extension FeedViewController {
    
    // MARK: setup
    
    func setupViews() {
        self.feedTable.delegate = self
        self.feedTable.dataSource = self
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = NSLocalizedString("feedScreen.title", comment: "Title for feed screen.")
    }
    
    func setupInitialValues() {
        self.hideActivityIndicator()
        self.showActivityIndicator()
        updateFeed()
    }
    
}
