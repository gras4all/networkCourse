//
//  AddDescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 08.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class AddDescriptionViewController: BaseViewController {
    
    @IBOutlet weak var filteredImageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var addDescriptionLabel: UILabel!
    
    var filteredImage: UIImage?
    
    // MARK: life cycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        bindImage()
    }
    
    // MARK: UI Actions
    @objc func share() {
        postimage()
    }
    
}

private extension AddDescriptionViewController {
    
    // MARK: Setup
    func setupViews() {
        addDescriptionLabel.text = NSLocalizedString("addDescriptionLabel.text", comment: "Text for post description label.")
    }
    
    func bindImage() {
        filteredImageView.image = filteredImage
    }
       
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("shareButton.text", comment: "Text for share button."), style: .plain, target: self, action: #selector(share))
    }
    
}
