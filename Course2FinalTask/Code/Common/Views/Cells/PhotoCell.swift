//
//  PhotoCell.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 17.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

final class PhotoCell: UICollectionViewCell {

    @IBOutlet var photoImage: UIImageView!
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Public
    
    func configure(image: String) {
        photoImage.kf.setImage(with: URL(string: image))
    }
}
