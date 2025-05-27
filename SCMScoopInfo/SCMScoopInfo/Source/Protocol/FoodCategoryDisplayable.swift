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
    
    var selectedCategory: Category { get set }
    var selectedFiltering: AroundFilterType { get set }
    
    var isLoading: Bool { get set }
    var lastStoreID: String { get set }
    
    func getPopularKeywords() async throws -> [String]
    func getPopularStoresInfo() async throws -> [RealtimePopularScoopEntity]
    func getAroundStoreInfo(_ round: AroundType) async throws -> [AroundStoreInfoEntity]
    func postStoreLikeStatus(store id: String, like status: Bool) async throws
}
