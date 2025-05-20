//
//  AroundType.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/20/25.
//

import Foundation

public enum AroundType: String {
    case 픽슐랭
    case 마이스쿱 = "My Scoop"
    
    var text: String {
        return self.rawValue
    }
}
