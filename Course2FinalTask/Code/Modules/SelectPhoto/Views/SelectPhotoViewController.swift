//
//  SelectPhotoViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 06.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class SelectPhotoViewController: BaseViewController {
    
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
        setupViews()
        setupNavigationBar()
    }

}

private extension SelectPhotoViewController {
    
    func setupViews() {
        galleryCollection.register(self.cellNib,
        forCellWithReuseIdentifier: self.cellReuseID)
        galleryCollection.delegate = self
        galleryCollection.dataSource = self
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = NSLocalizedString("newPostScreen.title", comment: "Title for new post screen.")
    }
    
}
