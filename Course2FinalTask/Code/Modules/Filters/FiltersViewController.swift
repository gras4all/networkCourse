//
//  FiltersViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 08.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class FiltersViewController: BaseViewController {
    
    typealias FilterImage = (title: String?, image: UIImage?, thumbnailImage: UIImage?)
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    let cellReuseID = String(describing: FilterCell.self)
    let cellNib = UINib(nibName: String(describing: FilterCell.self), bundle: nil)
    
    var selectedImage: FilterImage?
    
    var resultImage: UIImage?
    
    var filters: [FilterImage] = []
    
    private var filtersImages: [UIImage?] = []
    
    let queue: OperationQueue = {
        var queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    let filter = Filters()
    
    // MARK: life cycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFilters()
        setupViews()
        setupNavigationBar()
        bindImage()
        self.createFiltersImages()
    }
    
    // MARK: Setup UI
    
    private func setupViews() {
        filtersCollectionView.register(self.cellNib,
        forCellWithReuseIdentifier: self.cellReuseID)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Filters"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(goNext))
    }
    
    private func bindImage() {
        selectedImageView.image = selectedImage?.image
    }
    
    private func prepareFilters() {
        filters = filter.filterArray.map { (title: $0, image: nil, thumbnailImage: nil) }
    }
    
    private func createFiltersImages() {
        for (index, filter) in filter.filterArray.enumerated() {
            let operation = FilterImageOperation(inputImage: selectedImage?.thumbnailImage, filter: filter)
            operation.completionBlock = { [weak self] in
                guard let self = self else { return }
                self.filters[index].thumbnailImage = operation.outputImage
            }
            queue.addOperation(operation)
        }
        queue.waitUntilAllOperationsAreFinished()
        DispatchQueue.main.async {
            self.filtersCollectionView.reloadData()
        }
    }
    
    // MARK: UI Actions
    @objc func goNext() {
        let storyboard = UIStoryboard(name: "Filters", bundle: nil)
        let addDescriptionController = storyboard.instantiateViewController(withIdentifier: String(describing: AddDescriptionViewController.self)) as! AddDescriptionViewController
        addDescriptionController.filteredImage = resultImage
        self.navigationController?.pushViewController(addDescriptionController, animated: true)
    }
    
}

extension FiltersViewController: UICollectionViewDataSource,
                                 UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseID, for: indexPath) as? FilterCell else {
            fatalError("Wrong cell")
        }
        let filter = filters[indexPath.row]
        cell.configure(title: filter.title ?? "-", image: filter.thumbnailImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = filters[indexPath.row]
        let operation = FilterImageOperation(inputImage: selectedImage?.image, filter: image.title ?? "")
        operation.completionBlock = { [weak self] in
            guard let self = self else { return }
            self.resultImage = operation.outputImage
            DispatchQueue.main.async {
                self.selectedImageView.image = self.resultImage
                self.hideActivityIndicator()
            }
        }
        self.showActivityIndicator()
        queue.addOperation(operation)
    }
    
}
