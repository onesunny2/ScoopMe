//
//  ReceiptOrderResponseDTO.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation

struct ReceiptOrderResponseDTO: Codable {
    let paymentID: String
    let orderItem: OrderResponseDTO
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case paymentID = "payment_id"
        case orderItem = "order_item"
        case createdAt
        case updatedAt
    }
}

// MARK: - OrderResponseDTO
struct OrderResponseDTO: Codable {
    let orderID: String
    let orderCode: String
    let totalPrice: Double
    let store: StoreSummaryDTOOrder
    let orderMenuList: [OrderMenuDTO]
    let paidAt, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case store
        case orderMenuList = "order_menu_list"
        case paidAt
        case createdAt
        case updatedAt
    }
}
