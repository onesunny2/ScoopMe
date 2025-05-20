//
//  FoodCategoryDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

public protocol FoodCategoryDisplayable: AnyObject {
    
    var categoryNames: [String] { get set }
    var categoryImages: [Image] { get set }
    
    func getPopularKeyword() async -> PopularSearchKeywordEntity
    func getPopularStoreInfo() async -> RealtimePopularScoopEntity
    func getAroundStoreInfo(
        _ round: AroundType,
        _ filter: AroundFilterType
    ) async -> AroundStoreInfoEntity
}
