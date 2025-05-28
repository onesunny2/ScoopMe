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
    
    @Published public var showAlert: Bool {
        didSet {
            _base.showAlert = showAlert
        }
    }
    
    @Published public var alertTitle: String {
        didSet {
            _base.alertTitle = alertTitle
        }
    }
    
    @Published public var alertMessage: String {
        didSet {
            _base.alertMessage = alertMessage
        }
    }
    
    public init(_ base: any StoreDetailDisplayable) {
        self._base = base
        self.showAlert = base.showAlert
        self.alertTitle = base.alertTitle
        self.alertMessage = base.alertMessage
    }
    
    public func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity {
        try await _base.getStoreDetailInfo(id: id)
    }
    
    public func getStoreDetailMenu(id: String) async throws -> DetailMenu {
        try await _base.getStoreDetailMenu(id: id)
    }
    
    public func  checkTokenValidation(_ error: any Error, complete: @escaping () async throws -> ()) async {
        await _base.checkTokenValidation(error, complete: complete)
    }
}
