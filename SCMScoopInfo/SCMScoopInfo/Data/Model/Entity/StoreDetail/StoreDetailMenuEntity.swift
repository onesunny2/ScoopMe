//
//  StoreDetailMenuEntity.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import Foundation

public struct StoreDetailMenuEntity: Hashable {
    public let menuID: String
    public let category: String
    public let menuName: String
    public let description: String
    public let image: String
    public let price: Int
    public let priceString: String
    public let hashTag: String?
    public let soldoutStatus: Bool
    
    public init(
        menuID: String,
        category: String,
        menuName: String,
        description: String,
        image: String,
        price: Int,
        priceString: String,
        hashTag: String?,
        soldoutStatus: Bool
    ) {
        self.menuID = menuID
        self.category = category
        self.menuName = menuName
        self.description = description
        self.image = image
        self.price = price
        self.priceString = priceString
        self.hashTag = hashTag
        self.soldoutStatus = soldoutStatus
    }
}
