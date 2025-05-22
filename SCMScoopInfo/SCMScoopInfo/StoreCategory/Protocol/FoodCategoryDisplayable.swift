//
//  FoodCategoryDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import Combine

public protocol FoodCategoryDisplayable: AnyObject, ObservableObject {
    
    var categoryNames: [String] { get set }
    var categoryImages: [Image] { get set }
    
    var selectedCategory: String { get set }
    
    func getPopularKeywords() async -> [String]
    func getPopularStoresInfo() async -> [RealtimePopularScoopEntity]
    func getAroundStoreInfo(
        _ round: AroundType,
        _ filter: AroundFilterType
    ) async -> [AroundStoreInfoEntity]
}
