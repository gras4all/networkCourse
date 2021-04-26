//
//  FilterCell.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 09.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FilterCell: UICollectionViewCell {

    @IBOutlet weak var filterImage: UIImageView!
    
    @IBOutlet weak var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Public
    
    func configure(title: String, image: UIImage?) {
        filterLabel.text = title
        filterImage.image = image
    }
}
