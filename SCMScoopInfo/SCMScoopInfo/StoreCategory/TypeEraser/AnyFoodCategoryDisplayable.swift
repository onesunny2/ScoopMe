//
//  AnyFoodCategoryDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import Combine

public final class AnyFoodCategoryDisplayable: FoodCategoryDisplayable, ObservableObject {
    private let _base: any FoodCategoryDisplayable
    
    @Published public var categoryNames: [String] {
        didSet {
            _base.categoryNames = categoryNames
        }
    }
    
    @Published public var categoryImages: [Image] {
        didSet {
            _base.categoryImages = categoryImages
        }
    }
    
    @Published public var selectedCategory: Category {
        didSet {
            _base.selectedCategory = selectedCategory
        }
    }
    
    public init(_ base: any FoodCategoryDisplayable) {
        self._base = base
        self.categoryNames = base.categoryNames
        self.categoryImages = base.categoryImages
        self.selectedCategory = base.selectedCategory
    }
    
    public func getPopularKeywords() async throws -> [String] {
        try await _base.getPopularKeywords()
    }
    
    public func getPopularStoresInfo() async throws -> [RealtimePopularScoopEntity] {
        try await _base.getPopularStoresInfo()
    }
    
    public func getAroundStoreInfo(_ round: AroundType, _ filter: AroundFilterType) async -> [AroundStoreInfoEntity] {
        await _base.getAroundStoreInfo(round, filter)
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        try await _base.postStoreLikeStatus(store: id, like: status)
    }
}
