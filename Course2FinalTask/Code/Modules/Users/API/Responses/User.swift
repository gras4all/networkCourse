//
//  User.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 09.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    var id: String
    var username: String
    var fullName: String
    var avatar: String
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName
        case avatar
        case currentUserFollowsThisUser
        case currentUserIsFollowedByThisUser
        case followsCount
        case followedByCount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.avatar = try container.decode(String.self, forKey: .avatar)
        self.currentUserFollowsThisUser = try container.decode(Bool.self, forKey: .currentUserFollowsThisUser)
        self.currentUserIsFollowedByThisUser = try container.decode(Bool.self, forKey: .currentUserIsFollowedByThisUser)
        self.followsCount = try container.decode(Int.self, forKey: .followsCount)
        self.followedByCount = try container.decode(Int.self, forKey: .followedByCount)
    }
    
}



