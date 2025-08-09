//
//  EditContent.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 8/6/25.
//

import Foundation

public struct EditContent {
    public let title: String
    public let content: String
    
    public init(
        title: String,
        content: String
    ) {
        self.title = title
        self.content = content
    }
}
