//
//  AnyStoreDetailDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI
import Combine

public final class AnyStoreDetailDisplayable: StoreDetailDisplayable, ObservableObject {
    private let _base: any StoreDetailDisplayable
    
    public init(_base: any StoreDetailDisplayable) {
        self._base = _base
    }
    
    public func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity {
        try await _base.getStoreDetailInfo(id: id)
    }
}
