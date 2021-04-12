//
//  User.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 09.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import CoreData

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
    
    init(user: CUser) {
        self.id = user.id ?? ""
        self.username = user.username ?? ""
        self.fullName = user.fullName ?? ""
        self.avatar = user.avatar ?? ""
        self.currentUserFollowsThisUser = user.currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        self.followsCount = Int(user.followsCount)
        self.followedByCount = Int(user.followedByCount)
    }
    
    func prepareForSave() {
        let user = CoreDataManager.shared.createObject(from: CUser.self)
        user.id = id
        user.username = username
        user.avatar = avatar
        user.fullName = fullName
        user.currentUserFollowsThisUser = currentUserFollowsThisUser
        user.currentUserIsFollowedByThisUser = currentUserIsFollowedByThisUser
        user.followedByCount = Int16(followedByCount)
        user.followsCount = Int16(followsCount)
    }
    
}



