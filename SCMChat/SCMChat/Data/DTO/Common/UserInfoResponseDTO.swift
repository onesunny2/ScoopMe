//
//  UserInfoResponseDTO.swift
//  SCMChat
//
//  Created by Lee Wonsun on 6/29/25.
//

import Foundation

struct UserInfoResponseDTO: Codable {
    let userID: String
    let nick: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
}
