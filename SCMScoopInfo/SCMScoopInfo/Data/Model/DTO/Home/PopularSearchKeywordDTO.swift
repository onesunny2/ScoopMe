//
//  PopularSearchKeywordDTO.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/22/25.
//

import Foundation

struct PopularSearchKeywordDTO: Codable {
    let data: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([String].self, forKey: .data)
    }
}
