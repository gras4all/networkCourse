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
    
    // MARK: setup
    
    private func setupViews() {
        self.usersTable.delegate = self
        self.usersTable.dataSource = self
    }
    
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = usersTable.dequeueReusableCell(withIdentifier: String(describing: UsersCell.self)) as! UsersCell
         cell.setUser(user: users[indexPath.row])
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileController = storyboard.instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
        profileController.user = self.users[indexPath.row]
        navigationController?.pushViewController(profileController, animated: true)
    }
    
}
