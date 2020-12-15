//
//  AddDescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 08.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class AddDescriptionViewController: BaseViewController {
    
    @IBOutlet weak var filteredImageView: UIImageView!
    @IBOutlet weak var descriptionField: UITextField!
    
    var filteredImage: UIImage?
    
    // MARK: life cycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        bindImage()
    }
       
    private func setupViews() {}
    
    private func bindImage() {
        filteredImageView.image = filteredImage
    }
       
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(share))
    }
    
    // MARK: UI Actions
    @objc func share() {
        postimage()
    }
    
}

// MARK: API methods
private extension AddDescriptionViewController {
    
    private func postimage() {
        if let image = filteredImage {
            self.showActivityIndicator()
            let strImage = Base64Converter.convertImageToBase64String(image: image)
            NetworkManager.shared.createPostRequest(image: strImage, description: descriptionField.text ?? "", success: { [weak self] post in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.hideActivityIndicator(completion: { [weak self] in
                        guard let self = self else { return }
                        let tabsController = self.parent?.parent as? TabBarController
                        let feedNavViewController = tabsController?.viewControllers?[0] as? UINavigationController
                        let feedController = NavigationManager.shared.getFeedViewController()
                        feedNavViewController?.viewControllers = [feedController]
                        self.navigationController?.popToRootViewController(animated: false)
                        tabsController?.selectedIndex = 0
                    })
                }
            }, errorHandler: { [weak self] error in
                  guard let _self = self else { return }
                  DispatchQueue.main.async {
                      _self.hideActivityIndicator(completion: { [weak self] in
                       guard let _self = self else { return }
                       NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                       })
                  }
            })
        }
    }
    
}
