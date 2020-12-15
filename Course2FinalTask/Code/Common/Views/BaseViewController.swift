//
//  BaseViewController.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 06.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var activityIndicator: ActivityIndicatorViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ivc = storyboard.instantiateViewController(withIdentifier: String(describing: ActivityIndicatorViewController.self)) as! ActivityIndicatorViewController
        ivc.modalPresentationStyle = .overFullScreen
        return ivc
    }()
    
    func showActivityIndicator(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.navigationController?.topViewController?.present(self.activityIndicator, animated: false, completion: completion)
        }
    }
    
    func hideActivityIndicator(completion: (() -> Void)? = nil) {
        activityIndicator.dismiss(animated: false, completion: completion)
    }
    
    
    

}
