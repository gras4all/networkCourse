//
//  ProfileDataSource.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 30.04.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

struct ProfileDataSource {
    let numberOfItemsPerRow = 3
    var user: User?
    var posts: [Post]?
    var followed: [User]?
}
