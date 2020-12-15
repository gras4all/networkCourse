//
//  LoginResponse.swift
//  Course2FinalTask
//
//  Created by Андрей Груненков on 03.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.token = try container.decode(String.self, forKey: .token)
    }
    
}

