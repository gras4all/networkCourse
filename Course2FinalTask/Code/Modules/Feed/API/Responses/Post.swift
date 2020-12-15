//
//  Post.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 04.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

struct Post: Decodable {
    
    var id: String
    var description: String
    var image: String
    var createdTime: Date?
    var currentUserLikesThisPost: Bool
    var likedByCount: Int
    var author: String
    var authorUsername: String
    var authorAvatar: String
    
    private var _dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case image
        case createdTime
        case currentUserLikesThisPost
        case likedByCount
        case author
        case authorUsername
        case authorAvatar
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        let time = try container.decode(String.self, forKey: .createdTime)
        self.createdTime = _dateFormatter.date(from: time)
        self.currentUserLikesThisPost = try container.decode(Bool.self, forKey: .currentUserLikesThisPost)
        self.likedByCount = try container.decode(Int.self, forKey: .likedByCount)
        self.author = try container.decode(String.self, forKey: .author)
        self.authorUsername = try container.decode(String.self, forKey: .authorUsername)
        self.authorAvatar = try container.decode(String.self, forKey: .authorAvatar)
    }
    
}


