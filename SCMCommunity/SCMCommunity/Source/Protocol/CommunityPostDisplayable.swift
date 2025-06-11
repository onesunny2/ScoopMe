//
//  CommunityPostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import Foundation
import Combine

public protocol CommunityPostDisplayable: AnyObject, ObservableObject {
    typealias postForPagination = (data: [CommunityPostEntity], next: String)
    
    func getCommunityPost(max distance: Int, orderBy: TimelineFilter, next: String?) async throws -> postForPagination
    func postStoreLikeStatus(store id: String, like status: Bool) async throws
}
