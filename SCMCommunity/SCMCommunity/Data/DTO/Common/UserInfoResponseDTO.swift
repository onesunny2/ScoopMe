//
//  UserInfoResponseDTO.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/8/25.
//

import Foundation

public struct UserInfoResponseDTO: Hashable, Codable {
    public let userId: String
    public let nick: String
    public let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick, profileImage
    }
    
    public init(
        userId: String,
        nick: String,
        profileImage: String?
    ) {
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}
