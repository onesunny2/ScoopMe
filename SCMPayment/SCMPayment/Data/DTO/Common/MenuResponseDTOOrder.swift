//
//  MenuResponseDTOOrder.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/13/25.
//

import Foundation

struct MenuResponseDTOOrder: Codable {
    let id, category, name, description, originInformation: String
    let price: Int?
    let tags: [String]
    let menuImageUrl: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, category, name, description
        case originInformation = "origin_information"
        case price
        case tags
        case menuImageUrl = "menu_image_url"
        case createdAt
        case updatedAt
    }
}
