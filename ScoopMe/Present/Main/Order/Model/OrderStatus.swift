//
//  OrderStatus.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/10/25.
//

import Foundation

struct OrderStatus: Hashable {
    let orderNum: String
    let storeName: String
    let orderDate: String
    let currentOrder: [CurrentStatus]
    
    init(
        orderNum: String,
        storeName: String,
        orderDate: String,
        currentOrder: [CurrentStatus]
    ) {
        self.orderNum = orderNum
        self.storeName = storeName
        self.orderDate = orderDate
        self.currentOrder = currentOrder
    }
}

struct CurrentStatus: Hashable {
    let orderType: OrderType
    let isCompleted: Bool
    let completedTime: String?
}

enum OrderType: String {
    case 승인대기
    case 주문승인
    case 조리_중 = "조리 중"
    case 픽업대기
    case 픽업완료
    
    var text: String {
        return self.rawValue
    }
}

let dummyOrderStatus: OrderStatus = OrderStatus(
    orderNum: "A4922",
    storeName: "스쿱미 츄르 가게",
    orderDate: "2025년 6월 10일 오후 8시 17분",
    currentOrder: [
        CurrentStatus(orderType: .승인대기, isCompleted: true, completedTime: "오후 5:00"),
        CurrentStatus(orderType: .주문승인, isCompleted: true, completedTime: "오후 5:02"),
        CurrentStatus(orderType: .조리_중, isCompleted: false, completedTime: nil),
        CurrentStatus(orderType: .픽업대기, isCompleted: false, completedTime: nil),
        CurrentStatus(orderType: .픽업완료, isCompleted: false, completedTime: nil)
    ]
)
