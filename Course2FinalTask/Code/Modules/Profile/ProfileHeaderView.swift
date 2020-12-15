//
//  ProfileHeaderView.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 23.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate {
    func didFollowersTap(userId: String /*DataProvider.User.Identifier*/)
    func didFollowingTap(userId: String /*DataProvider.User.Identifier*/)
    func didFollowBtnTap(userId: String /*DataProvider.User.Identifier*/)
}

class ProfileHeaderView: UICollectionReusableView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user: User?
    var delegate: ProfileHeaderViewDelegate?
    
    // MARK: life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 35
        followButton.layer.cornerRadius = 8
        followButton.isHidden = true
        let followersTapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followersLabelTap))
        followersLabel.addGestureRecognizer(followersTapGuestureRecognizer)
        followersLabel.isUserInteractionEnabled = true
        let followingTapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(followingLabelTap))
        followingLabel.addGestureRecognizer(followingTapGuestureRecognizer)
        followingLabel.isUserInteractionEnabled = true
    }
    
    // MARK: Public
    
    func setUser(user: User?) {
        self.user = user
    }
    
    // MARK: inerface actions
    
    @IBAction func didFollowBtnTap(_ sender: Any) {
        if let user = user {
            delegate?.didFollowBtnTap(userId: user.id)
        }
    }
    
    
    @objc func followersLabelTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            if let user = user {
                delegate?.didFollowersTap(userId: user.id)
            }
        }
    }
    
    @objc func followingLabelTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
              if let user = user {
                delegate?.didFollowingTap(userId: user.id)
            }
        }
    }
    
}
