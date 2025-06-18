//
//  AnyCommunityPostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import SwiftUI
import Combine

//public final class AnyCommunityPostDisplayable: CommunityPostDisplayable, ObservableObject {
//    private let _base: any CommunityPostDisplayable
//    
//    public init(_ base: any CommunityPostDisplayable) {
//        self._base = base
//    }
//    
//    public func getCommunityPost(max distance: Int, orderBy: TimelineFilter, next: String?) async throws -> postForPagination {
//        try await _base.getCommunityPost(max: distance, orderBy: orderBy, next: next)
//    }
//    
//    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
//        try await _base.postStoreLikeStatus(store: id, like: status)
//    }
//}
