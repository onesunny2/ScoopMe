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
    
    // ObservableObject 요구사항 충족을 위한 Published 속성
    @Published public var categoryNames: [String] {
        didSet {
            // 내부 객체의 값도 업데이트
            _base.categoryNames = categoryNames
        }
    }
    
    @Published public var categoryImages: [Image] {
        didSet {
            // 내부 객체의 값도 업데이트
            _base.categoryImages = categoryImages
        }
    }
    
    @Published public var selectedCategory: String {
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
    
    public func getPopularKeywords() async -> PopularSearchKeywordEntity {
        await _base.getPopularKeywords()
    }
    
    public func getPopularStoresInfo() async -> [RealtimePopularScoopEntity] {
        await _base.getPopularStoresInfo()
    }
    
    public func getAroundStoreInfo(_ round: AroundType, _ filter: AroundFilterType) async -> [AroundStoreInfoEntity] {
        await _base.getAroundStoreInfo(round, filter)
    }
}
