//
//  ProfileViewController+CollectionView.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension ProfileViewController: UICollectionViewDataSource,
                                 UICollectionViewDelegate,
                                 UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseID, for: indexPath) as? PhotoCell else {
            fatalError("Wrong cell")
        }
        if let posts = dataSource.posts {
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
            + (flowLayout.minimumInteritemSpacing * CGFloat(dataSource.numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(dataSource.numberOfItemsPerRow))
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
            headerView.followButton.isHidden = (dataSource.user?.id == AppSettings.shared.currentUser?.id) || dataSource.followed == nil
            headerView.usernameLabel.text = dataSource.user?.fullName
            headerView.followersLabel.text =  NSLocalizedString("profileScreen.followersText", comment: "Text for followers.") + ": \(dataSource.user?.followedByCount ?? 0)"
            headerView.followingLabel.text = NSLocalizedString("profileScreen.followingText", comment: "Text for following.") + ": \(dataSource.user?.followsCount ?? 0)"
            headerView.profileImageView.kf.setImage(with: URL(string: dataSource.user?.avatar ?? ""))
            headerView.setUser(user: dataSource.user)
              headerView.delegate = self
              headerView.followButton.setTitle(self.isFollowed ? NSLocalizedString("unfollowButton.text", comment: "Text for unfollow button.") : NSLocalizedString("followButton.text", comment: "Text for follow button."), for: .normal)
              UIView.performWithoutAnimation({
                  headerView.followButton.setTitle(self.isFollowed ? NSLocalizedString("unfollowButton.text", comment: "Text for unfollow button.") : NSLocalizedString("followButton.text", comment: "Text for follow button."), for: .normal)
                  headerView.followButton.layoutIfNeeded()
              })
              
              return headerView
         default:
             assert(false, "Invalid element type")
      }
    }
}
