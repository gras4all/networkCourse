//
//  FiltersViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 08.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class FiltersViewController: BaseViewController {
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    let cellReuseID = String(describing: FilterCell.self)
    let cellNib = UINib(nibName: String(describing: FilterCell.self), bundle: nil)
    
    var dataSource: FiltersDataSource = FiltersDataSource()
    
    let queue: OperationQueue = {
        var queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    // MARK: life cycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.prepareFilters()
        setupViews()
        setupNavigationBar()
        bindImage()
        createFiltersImages()
    }
    
    private func createFiltersImages() {
        for (index, filter) in dataSource.filter.filterArray.enumerated() {
            let operation = FilterImageOperation(inputImage: dataSource.selectedImage?.thumbnailImage, filter: filter)
            operation.completionBlock = { [weak self] in
                guard let self = self else { return }
                self.dataSource.filters[index].thumbnailImage = operation.outputImage
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
        addDescriptionController.filteredImage = dataSource.resultImage
        self.navigationController?.pushViewController(addDescriptionController, animated: true)
    }
    
}

private extension FiltersViewController {
    
    // MARK: Setup UI
    
    func setupViews() {
        filtersCollectionView.register(self.cellNib,
        forCellWithReuseIdentifier: self.cellReuseID)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = NSLocalizedString("filtersScreen.title", comment: "Title for filters screen.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("nextButton.text", comment: "Text for next button."), style: .plain, target: self, action: #selector(goNext))
    }
    
    func bindImage() {
        selectedImageView.image = dataSource.selectedImage?.image
    }
    
}
