//
//  SelectPhotoViewController+CollectionView.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension SelectPhotoViewController: UICollectionViewDataSource,
                                 UICollectionViewDelegate,
                                 UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseID, for: indexPath) as? PhotoCell else {
            fatalError("Wrong cell")
        }
        cell.photoImage.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !NetworkManager.shared.isOffline else {
            NavigationManager.shared.presentOfflineMessage(vc: self)
            return
        }
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        let filtersController = storyboard.instantiateViewController(withIdentifier: String(describing: FiltersViewController.self)) as! FiltersViewController
        filtersController.dataSource.selectedImage = (title: nil, image: images[indexPath.row], thumbnailImage: thumbnailImages[indexPath.row])

        self.navigationController?.pushViewController(filtersController, animated: true)
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
    
}

