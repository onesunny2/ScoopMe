//
//  JoinResponseDTO.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/14/25.
//

import Foundation

struct JoinResponseDTO: Codable {
    let user_id: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
}
