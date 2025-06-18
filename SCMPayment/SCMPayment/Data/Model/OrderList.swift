//
//  OrderList.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation

public struct OrderList: Codable {
    public let storeID: String
    public let orderMenuList: [OrderMenu]
    public let totalPrice: Int
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case orderMenuList = "order_menu_list"
        case totalPrice = "total_price"
    }
    
    public init(storeID: String, orderMenuList: [OrderMenu], totalPrice: Int) {
        self.storeID = storeID
        self.orderMenuList = orderMenuList
        self.totalPrice = totalPrice
    }
}

public struct OrderMenu: Codable {
    public let menuID: String
    public let quantity: Int
    public let price: Int
    
    enum CodingKeys: String, CodingKey {
        case menuID = "menu_id"
        case quantity
        case price
    }
    
    public init(menuID: String, quantity: Int, price: Int) {
        self.menuID = menuID
        self.quantity = quantity
        self.price = price
    }
}
