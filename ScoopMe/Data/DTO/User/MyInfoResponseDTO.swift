//
//  MyInfoResponseDTO.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/19/25.
//

import Foundation

struct MyInfoResponseDTO: Codable {
    let user_id: String
    let email: String
    let nick: String
    let profileImage: String?
    let phoneNum: String?
}
