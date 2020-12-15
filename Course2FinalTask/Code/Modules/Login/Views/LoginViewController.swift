//
//  LoginViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 03.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func tapSignIn(_ sender: Any) {
        showActivityIndicator()
        NetworkManager.shared.loginRequest(username: usernameField.text ?? "",
                                           password: passwordField.text ?? "",
                                           success: { [weak self] in
                                               guard let _self = self else { return }
                                               _self.sendCurrentUserRequest()
                                           },
                                           errorHandler: { [weak self] error in
                                               guard let _self = self else { return }
                                               DispatchQueue.main.async {
                                                   _self.hideActivityIndicator(completion: { [weak self] in
                                                    guard let _self = self else { return }
                                                    NavigationManager.shared.presentErrorAlert(statusCode: error, vc: _self)
                                               })
                                            }
                                           })
    }
    
    private func sendCurrentUserRequest() {
        NetworkManager.shared.getCurrentUser(success: { user in
            AppSettings.shared.currentUser = user
            DispatchQueue.main.async {
                self.hideActivityIndicator(completion: {
                    guard let nc = self.navigationController else { return }
                    NavigationManager.shared.setupTabBarViewControllerAsRoot(nc: nc)
                })
            }
        },
        errorHandler: { [weak self] error in
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


