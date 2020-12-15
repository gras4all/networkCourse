//
//  UsersCell.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 17.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class UsersCell: UITableViewCell {
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    // MARK: - Public
    
    func setUser(user: User) {
        avatarImage.kf.setImage(with: URL(string: user.avatar))
        nameLabel.text = user.fullName
    }
    
}
