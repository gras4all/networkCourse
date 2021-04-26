//
//  Base64Converter.swift
//  Course5Homework
//
//  Created by Андрей Груненков on 23.09.2020.
//  Copyright © 2020 Андрей Груненков. All rights reserved.
//

import Foundation
import UIKit

final class Base64Converter {
    
    static func encodeStringToBase64(string: String) -> String? {
        let utf8str = string.data(using: .utf8)
        return utf8str?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    static func convertImageToBase64String(image : UIImage ) -> String {
        let strBase64 =  image.pngData()?.base64EncodedString()
        return strBase64!
    }
    
}


