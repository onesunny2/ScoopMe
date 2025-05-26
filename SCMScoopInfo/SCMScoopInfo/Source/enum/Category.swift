//
//  Category.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/22/25.
//

import SwiftUI

public enum Category: String, CaseIterable {
    case 커피
    case 패스트푸드
    case 디저트
    case 베이커리
    case 더보기
    case 한식
    case 일식
    case 분식
    case 샐러드
    case 샌드위치
    
    public var text: String {
        return self.rawValue
    }
    
    public var image: Image {
        switch self {
        case .커피: Image(.coffee)
        case .패스트푸드: Image(.fastFood)
        case .디저트: Image(.dessert)
        case .베이커리: Image(.bakery)
        case .더보기: Image(.more)
        case .한식: Image(.hansik)
        case .일식: Image(.ilsik)
        case .분식: Image(.bunsik)
        case .샐러드: Image(.salad)
        case .샌드위치: Image(.sandwich)
        }
    }
    
    public static func from(_ string: String) -> Category {
        guard let category = Category(rawValue: string) else { return .커피 }
        return category
    }
}
