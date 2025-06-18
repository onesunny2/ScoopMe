//
//  OrderCreateResponseDTO.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation

struct OrderCreateResponseDTO: Codable {
    let order_id: String
    let order_code: String
    let total_price: Int
    let createdAt: String
    let updatedAt: String
}
