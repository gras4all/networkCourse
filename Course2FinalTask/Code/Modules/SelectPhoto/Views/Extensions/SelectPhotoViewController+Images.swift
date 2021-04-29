//
//  SelectViewController+Images.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation
import UIKit

extension SelectPhotoViewController {
    
    func getImages() -> [UIImage] {
        return [UIImage(named: "new1")!,
                UIImage(named: "new2")!,
                UIImage(named: "new3")!,
                UIImage(named: "new4")!,
                UIImage(named: "new5")!,
                UIImage(named: "new6")!,
                UIImage(named: "new7")!]
    }
    
    func getThumbnailsImages() -> [UIImage] {
        return [UIImage(named: "newThumb1")!,
                UIImage(named: "newThumb2")!,
                UIImage(named: "newThumb3")!,
                UIImage(named: "newThumb4")!,
                UIImage(named: "newThumb5")!,
                UIImage(named: "newThumb6")!,
                UIImage(named: "newThumb7")!]
    }
    
}
