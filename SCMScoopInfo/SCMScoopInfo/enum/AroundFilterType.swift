//
//  AroundFilterType.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import Foundation

public enum AroundFilterType: String {
    case 거리순
    case 별점순 = "별점 높은 순"
    case 즐겨찾기순
    case 주문_많은순 = "주문 많은 순"
    
    var text: String {
        return self.rawValue
    }
}
