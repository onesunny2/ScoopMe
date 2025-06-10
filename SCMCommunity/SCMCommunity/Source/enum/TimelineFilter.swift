//
//  TimelineFilter.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/29/25.
//

import Foundation

public enum TimelineFilter: String {
    case 최신순
    case 좋아요순
    
    public var text: String {
        return self.rawValue
    }
    
    public var query: String {
        switch self {
        case .최신순:
            return "createdAt"
        case .좋아요순:
            return "likes"
        }
    }
}
