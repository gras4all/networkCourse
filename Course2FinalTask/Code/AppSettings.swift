//
//  AppSettings.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 05.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

class AppSettings {
    
    static var shared: AppSettings = {
        return AppSettings()
    }()
    
    var currentUser: User?
    
    private init() {  }
    
}
