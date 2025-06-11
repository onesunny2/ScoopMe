//
//  PaymentURL.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation
import SCMNetwork

public enum PaymentURL {
    case orders(access: String, orderList: OrderList)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .orders:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .orders:
            return "/v1/orders"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        default:
            return nil
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        case let .orders(_, orderList):
            return [
                "store_id": orderList.storeID,
                "order_menu_list": orderList.orderMenuList.map { menu in
                    [
                        "menu_id": menu.menuID,
                        "quantity": menu.quantity
                    ] as [String: Any]
                },
                "total_price": orderList.totalPrice
            ]
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .orders(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}
