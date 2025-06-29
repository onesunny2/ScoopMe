//
//  AroundFilterType.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import Foundation

public enum AroundFilterType: String {
    case distance
    case reviews
    case orders
    
    public var query: String {
        return self.rawValue
    }
    
    public var text: String {
        switch self {
        case .distance: return "거리순"
        case .reviews: return "리뷰순"
        case .orders: return "주문순"
        }
    }
}
