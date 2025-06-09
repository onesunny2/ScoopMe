//
//  AnyCommunityPostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 5/30/25.
//

import SwiftUI
import Combine

public final class AnyCommunityPostDisplayable: CommunityPostDisplayable, ObservableObject {
    private let _base: any CommunityPostDisplayable
    
    @Published public var selectedFiltering: TimelineFilter {
        didSet {
            _base.selectedFiltering = selectedFiltering
        }
    }
    
    @Published public var isLoading: Bool {
        didSet {
            _base.isLoading = isLoading
        }
    }
    
    @Published public var lastStoreID: String {
        didSet {
            _base.lastStoreID = lastStoreID
        }
    }
    
    public init(_ base: any CommunityPostDisplayable) {
        self._base = base
        self.selectedFiltering = base.selectedFiltering
        self.isLoading = base.isLoading
        self.lastStoreID = base.lastStoreID
    }
    
    public func getCommunityPost(max distance: Int, orderBy: TimelineFilter, next: String?) async throws -> [CommunityPostEntity] {
        try await _base.getCommunityPost(max: distance, orderBy: orderBy, next: next)
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        try await _base.postStoreLikeStatus(store: id, like: status)
    }
}
