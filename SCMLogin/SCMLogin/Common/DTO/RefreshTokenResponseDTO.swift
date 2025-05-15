//
//  RefreshTokenResponseDTO.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation

struct RefreshTokenResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}
