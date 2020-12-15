//
//  SelectPhotoViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 06.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class SelectPhotoViewController: BaseViewController {
    
    @IBOutlet weak var galleryCollection: UICollectionView!
    
    let cellReuseID = String(describing: PhotoCell.self)
    let cellNib = UINib(nibName: String(describing: PhotoCell.self), bundle: nil)
    
    let numberOfItemsPerRow = 3
    
    var images: [UIImage] {
        return getImages()
    }
    
    var thumbnailImages: [UIImage] {
        return getThumbnailsImages()
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupViews()
        _setupNavigationBar()
    }
    
    private func _setupViews() {
        galleryCollection.register(self.cellNib,
        forCellWithReuseIdentifier: self.cellReuseID)
        galleryCollection.delegate = self
        galleryCollection.dataSource = self
    }
    
    private func _setupNavigationBar() {
        self.navigationItem.title = "New post"
    }

}

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
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        let filtersController = storyboard.instantiateViewController(withIdentifier: String(describing: FiltersViewController.self)) as! FiltersViewController
        filtersController.selectedImage = (title: nil, image: images[indexPath.row], thumbnailImage: thumbnailImages[indexPath.row])

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

private extension SelectPhotoViewController {
    
    func getImages() -> [UIImage] {
        return [UIImage(named: "new1")!,
                UIImage(named: "new2")!,
                UIImage(named: "new3")!,
                UIImage(named: "new4")!,
                UIImage(named: "new5")!,
                UIImage(named: "new6")!,
                UIImage(named: "new7")!]
    }
    
    func getThumbnailsImages() -> [UIImage] {
        return [UIImage(named: "newThumb1")!,
                UIImage(named: "newThumb2")!,
                UIImage(named: "newThumb3")!,
                UIImage(named: "newThumb4")!,
                UIImage(named: "newThumb5")!,
                UIImage(named: "newThumb6")!,
                UIImage(named: "newThumb7")!]
    }
    
}
