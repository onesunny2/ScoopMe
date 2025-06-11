//
//  OrderStatusEntity.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation

public struct OrderStatusEntity: Hashable {
    public let orderNum: String
    public let storeName: String
    public let orderDate: String
    public let currentOrder: [CurrentStatus]
    public let orderedMenus: [OrderedMenu]
    public let totalQuantity: String
    public let totalPrice: String
    
    public init(
        orderNum: String,
        storeName: String,
        orderDate: String,
        currentOrder: [CurrentStatus],
        orderedMenus: [OrderedMenu],
        totalQuantity: String,
        totalPrice: String
    ) {
        self.orderNum = orderNum
        self.storeName = storeName
        self.orderDate = orderDate
        self.currentOrder = currentOrder
        self.orderedMenus = orderedMenus
        self.totalQuantity = totalQuantity
        self.totalPrice = totalPrice
    }
}

public struct CurrentStatus: Hashable {
    public let orderType: OrderType
    public let isCompleted: Bool
    public let completedTime: String?
    
    public init(orderType: OrderType, isCompleted: Bool, completedTime: String?) {
        self.orderType = orderType
        self.isCompleted = isCompleted
        self.completedTime = completedTime
    }
}

public struct OrderedMenu: Hashable {
    public let menuName: String
    public let quantity: String
    public let price: String
    public let imageURL: String
    
    public init(menuName: String, quantity: String, price: String, imageURL: String) {
        self.menuName = menuName
        self.quantity = quantity
        self.price = price
        self.imageURL = imageURL
    }
}

public enum OrderType: String {
    case 승인대기
    case 주문승인
    case 조리_중 = "조리 중"
    case 픽업대기
    case 픽업완료
    
    public var text: String {
        return self.rawValue
    }
    
    public var bodyQuery: String {
        switch self {
        case .승인대기: return "PENDING_APPROVAL"
        case .주문승인: return "APPROVED"
        case .조리_중: return "IN_PROGRESS"
        case .픽업대기: return "READY_FOR_PICKUP"
        case .픽업완료: return "PICKED_UP"
        }
    }
}

public let dummyOrderStatus: OrderStatusEntity = OrderStatusEntity(
    orderNum: "A4922",
    storeName: "스쿱미 냥츄르 어드벤쳐",
    orderDate: "2025년 6월 10일 오후 8시 17분",
    currentOrder: [
        CurrentStatus(orderType: .승인대기, isCompleted: true, completedTime: "오후 5:00"),
        CurrentStatus(orderType: .주문승인, isCompleted: true, completedTime: "오후 5:02"),
        CurrentStatus(orderType: .조리_중, isCompleted: false, completedTime: nil),
        CurrentStatus(orderType: .픽업대기, isCompleted: false, completedTime: nil),
        CurrentStatus(orderType: .픽업완료, isCompleted: false, completedTime: nil)
    ],
    orderedMenus: [
        OrderedMenu(
            menuName: "올리브 그린 새싹 도넛",
            quantity: "2EA",
            price: "3,200원",
            imageURL: Secret.baseURL + "/v1/data/menus/1748692151899.png"
        ),
        OrderedMenu(
            menuName: "레몬 민트 새싹 도넛",
            quantity: "3EA",
            price: "3,600원",
            imageURL: Secret.baseURL + "/v1/data/menus/1748713214481.jpg"
        )
    ],
    totalQuantity: "5EA",
    totalPrice: "17,200원"
)
