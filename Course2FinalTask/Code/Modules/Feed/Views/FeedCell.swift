//
//  FeedCell.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 17.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

protocol FeedCellDelegate: AnyObject {

    func didLikeTap(postId: String)
    func didLikesTap(postId: String)
    func didPostImageTap(postId: String)
    func didShowProfile(authorId: String)
    
}

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var bigLikeImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    weak var delegate: FeedCellDelegate?
    var post: Post! 
    
    private var _dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    // MARK: life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageTapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(postImageTap))
        imageTapGuestureRecognizer.numberOfTapsRequired = 2
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(imageTapGuestureRecognizer)
        let likesTapGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likesTap))
        likesLabel.addGestureRecognizer(likesTapGuestureRecognizer)
        likesLabel.isUserInteractionEnabled = true
        let avatarGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(avatarImageTap))
        avatarImg.addGestureRecognizer(avatarGuestureRecognizer)
        avatarImg.isUserInteractionEnabled = true
        let nameLabelGuestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userNameTap))
        nameLabel.addGestureRecognizer(nameLabelGuestureRecognizer)
        nameLabel.isUserInteractionEnabled = true
        likeButton.tintColor = .gray
    }
    
    // MARK: - Public
    
    func setPost(post: Post, isLiked: Bool = false) {
        self.post = post
        avatarImg.kf.setImage(with: URL(string: post.authorAvatar))
        nameLabel.text = post.authorUsername
        if let date = post.createdTime {
            dateLabel.isHidden = false
            dateLabel.text = _dateFormatter.string(from: date)
        } else {
            dateLabel.isHidden = true
        }
        postImage.kf.setImage(with: URL(string: post.image))
        likesLabel.text = "Likes: \(post.likedByCount)"
        descriptionLabel.text = post.description
        if post.currentUserLikesThisPost {
            likeButton.tintColor = UIView().tintColor!
        } else {
            likeButton.tintColor = .gray
        }
    }
    
    // MARK: inerface actions
    
    @objc func postImageTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.delegate?.didPostImageTap(postId: self.post.id)
            })
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.values = [0, 1, 1, 0]
            animation.keyTimes = [0, 0.1, 0.3, 0.6]
            animation.duration = 0.6
            animation.timingFunctions =
                [CAMediaTimingFunction(name: .linear),
                 CAMediaTimingFunction(name: .default),
                 CAMediaTimingFunction(name: .easeInEaseOut)]
            animation.isAdditive = true
            bigLikeImage.layer.add(animation, forKey: "showhide")
            CATransaction.commit()
        }
    }
    
    @objc func avatarImageTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            delegate?.didShowProfile(authorId: post.author)
        }
    }
    
    @objc func userNameTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            delegate?.didShowProfile(authorId: post.author)
        }
    }
    
    @objc func likesTap(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            delegate?.didLikesTap(postId: post.id)
        }
    }
    
    @IBAction func likeTap(_ sender: Any) {
        delegate?.didLikeTap(postId: post.id)
    }
    
}
