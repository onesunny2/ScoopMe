//
//  OrderListResponseDTO.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/13/25.
//

import Foundation

struct OrderListResponseDTO: Codable {
    let data: [OrderWithStatusResponseDTO]
}

struct OrderWithStatusResponseDTO: Codable {
    let orderID: String
    let orderCode: String
    let totalPrice: Double
    let review: Review?
    let store: StoreSummaryDTOOrder
    let orderMenuList: [OrderMenuDTO]
    let currentOrderStatus: String?
    let orderStatusTimeline: [OrderStatusTimeline]
    let paidAt: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderCode = "order_code"
        case totalPrice = "total_price"
        case review, store
        case orderMenuList = "order_menu_list"
        case currentOrderStatus = "current_order_status"
        case orderStatusTimeline = "order_status_timeline"
        case paidAt, createdAt, updatedAt
    }
}

struct Review: Codable {
    let id: String
    let rating: Double
}

struct OrderStatusTimeline: Codable {
    let status: String
    let completed: Bool
    let changedAt: String?
}
