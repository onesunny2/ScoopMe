//
//  StoreDetailDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI
import Combine

public protocol StoreDetailDisplayable: AnyObject, ObservableObject {
    
    func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity
    func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async
}
