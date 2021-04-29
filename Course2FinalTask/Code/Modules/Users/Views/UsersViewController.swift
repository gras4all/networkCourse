//
//  UsersViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 16.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class UsersViewController: UIViewController {

    @IBOutlet var usersTable: UITableView!
    
    var users: [User] = []
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}

private extension UsersViewController {
    
    // MARK: setup
    
    func setupViews() {
        self.usersTable.delegate = self
        self.usersTable.dataSource = self
    }
    
}

