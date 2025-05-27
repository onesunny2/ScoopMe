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
    public let price: String
    public let hashTag: String?
    
    public init(
        menuID: String,
        category: String,
        menuName: String,
        description: String,
        image: String,
        price: String,
        hashTag: String?
    ) {
        self.menuID = menuID
        self.category = category
        self.menuName = menuName
        self.description = description
        self.image = image
        self.price = price
        self.hashTag = hashTag
    }
}
