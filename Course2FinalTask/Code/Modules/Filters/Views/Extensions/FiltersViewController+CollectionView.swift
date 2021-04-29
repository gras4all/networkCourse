//
//  FiltersViewController+CollectionView.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension FiltersViewController: UICollectionViewDataSource,
                                 UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseID, for: indexPath) as? FilterCell else {
            fatalError("Wrong cell")
        }
        let filter = dataSource.filters[indexPath.row]
        cell.configure(title: filter.title ?? "-", image: filter.thumbnailImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = dataSource.filters[indexPath.row]
        let operation = FilterImageOperation(inputImage: dataSource.selectedImage?.image, filter: image.title ?? "")
        operation.completionBlock = { [weak self] in
            guard let self = self else { return }
            self.dataSource.resultImage = operation.outputImage
            DispatchQueue.main.async {
                self.selectedImageView.image = self.dataSource.resultImage
                self.hideActivityIndicator()
            }
        }
        self.showActivityIndicator()
        queue.addOperation(operation)
    }
    
}

