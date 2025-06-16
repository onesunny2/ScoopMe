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
    public let storeImageURL: String
    public let orderDate: String
    public var currentStatus: OrderType
    public var currentOrder: [CurrentStatus]
    public let orderedMenus: [OrderedMenu]
    public let totalQuantity: String
    public let totalPrice: String
    
    public init(
        orderNum: String,
        storeName: String,
        storeImageURL: String,
        orderDate: String,
        currentStatus: OrderType,
        currentOrder: [CurrentStatus],
        orderedMenus: [OrderedMenu],
        totalQuantity: String,
        totalPrice: String
    ) {
        self.orderNum = orderNum
        self.storeName = storeName
        self.storeImageURL = storeImageURL
        self.orderDate = orderDate
        self.currentStatus = currentStatus
        self.currentOrder = currentOrder
        self.orderedMenus = orderedMenus
        self.totalQuantity = totalQuantity
        self.totalPrice = totalPrice
    }
}

public struct CurrentStatus: Hashable {
    public let orderType: OrderType
    public var isCompleted: Bool
    public var completedTime: String?
    
    public init(orderType: OrderType, isCompleted: Bool, completedTime: String?) {
        self.orderType = orderType
        self.isCompleted = isCompleted
        self.completedTime = completedTime
    }
}

public struct OrderedMenu: Hashable {
    public let menuName: String
    public let quantity: Int
    public let stringQuantity: String
    public let price: Int
    public let stringPrice: String
    public let imageURL: String
    
    public init(
        menuName: String,
        quantity: Int,
        stringQuantity: String,
        price: Int,
        stringPrice: String,
        imageURL: String
    ) {
        self.menuName = menuName
        self.quantity = quantity
        self.stringQuantity = stringQuantity
        self.price = price
        self.stringPrice = stringPrice
        self.imageURL = imageURL
    }
}

public enum OrderType: String, CaseIterable {
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
    
    public init?(bodyQuery: String) {
        for orderType in OrderType.allCases {
            if orderType.bodyQuery == bodyQuery {
                self = orderType
                return
            }
        }
        return nil
    }
}

//public let dummyOrderStatus: [OrderStatusEntity] = [
//    OrderStatusEntity(
//        orderNum: "A4922",
//        storeName: "스쿱미 냥츄르 어드벤쳐",
//        storeImageURL: Secret.baseURL + "/v1/data/stores/andy-li-RndRFJ1v1kk_1748689676005.jpg",
//        orderDate: "2025년 6월 10일 오후 8시 17분",
//        currentOrder: [
//            CurrentStatus(orderType: .승인대기, isCompleted: true, completedTime: "오후 5:00"),
//            CurrentStatus(orderType: .주문승인, isCompleted: true, completedTime: "오후 5:02"),
//            CurrentStatus(orderType: .조리_중, isCompleted: false, completedTime: nil),
//            CurrentStatus(orderType: .픽업대기, isCompleted: false, completedTime: nil),
//            CurrentStatus(orderType: .픽업완료, isCompleted: false, completedTime: nil)
//        ],
//        orderedMenus: [
//            OrderedMenu(
//                menuName: "올리브 그린 새싹 도넛",
//                quantity: 2,
//                stringQuantity: "2EA",
//                price: 3200,
//                stringPrice: "3,200원",
//                imageURL: Secret.baseURL + "/v1/data/menus/1748692151899.png"
//            ),
//            OrderedMenu(
//                menuName: "레몬 민트 새싹 도넛",
//                quantity: 3,
//                stringQuantity: "3EA",
//                price: 3600,
//                stringPrice: "3,600원",
//                imageURL: Secret.baseURL + "/v1/data/menus/1748713214481.jpg"
//            )
//        ],
//        totalQuantity: "5EA",
//        totalPrice: "17,200원"
//    ),
//    OrderStatusEntity(
//        orderNum: "WS960730",
//        storeName: "내일은 수료식",
//        storeImageURL: Secret.baseURL + "/v1/data/stores/saahil-khatkhate-kfDsMDyX1K0_1748712227803.jpg",
//        orderDate: "2025년 6월 11일 오후 3시 45분",
//        currentOrder: [
//            CurrentStatus(orderType: .승인대기, isCompleted: true, completedTime: "오후 5:00"),
//            CurrentStatus(orderType: .주문승인, isCompleted: false, completedTime: nil),
//            CurrentStatus(orderType: .조리_중, isCompleted: false, completedTime: nil),
//            CurrentStatus(orderType: .픽업대기, isCompleted: false, completedTime: nil),
//            CurrentStatus(orderType: .픽업완료, isCompleted: false, completedTime: nil)
//        ],
//        orderedMenus: [
//            OrderedMenu(
//                menuName: "킹킹킹 피자킹",
//                quantity: 2,
//                stringQuantity: "2EA",
//                price: 3200,
//                stringPrice: "3,200원",
//                imageURL: Secret.baseURL + "/v1/data/menus/1748713236491.jpg"
//            )
//        ],
//        totalQuantity: "2EA",
//        totalPrice: "6,400원"
//    )
//]
