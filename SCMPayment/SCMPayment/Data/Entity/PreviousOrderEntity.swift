//
//  PreviousOrderEntity.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/16/25.
//

import Foundation

public struct PreviousOrderEntity: Hashable {
    public let orderCode: String
    public let storeName: String
    public let storeImageURL: String
    public let pickedDate: String
    public let orderedItems: String
    public let totalPrice: String
    public let review: Review?
    
    public init(
        orderCode: String,
        storeName: String,
        storeImageURL: String,
        pickedDate: String,
        orderedItems: String,
        totalPrice: String,
        review: Review?
    ) {
        self.orderCode = orderCode
        self.storeName = storeName
        self.storeImageURL = storeImageURL
        self.pickedDate = pickedDate
        self.orderedItems = orderedItems
        self.totalPrice = totalPrice
        self.review = review
    }
}
