//
//  UserInfoResponseDTO.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/8/25.
//

import Foundation

struct UserInfoResponseDTO: Codable {
    let userId: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick, profileImage
    }
}
