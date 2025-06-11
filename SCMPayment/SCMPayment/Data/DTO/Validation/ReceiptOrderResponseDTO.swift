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

// MARK: - StoreSummaryDTOOrder
struct StoreSummaryDTOOrder: Codable {
    let id, category, name, close: String
    let storeImageUrls: [String]
    let hashTags: [String]
    let geolocation: Geolocation
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, category, name, close
        case storeImageUrls = "store_image_urls"
        case hashTags
        case geolocation
        case createdAt
        case updatedAt
    }
}

// MARK: - Geolocation
struct Geolocation: Codable {
    let longitude, latitude: Double
}

// MARK: - OrderMenuDTO
struct OrderMenuDTO: Codable {
    let menu: MenuResponseDTOOrder
    let quantity: Double
}

// MARK: - MenuResponseDTOOrder
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
