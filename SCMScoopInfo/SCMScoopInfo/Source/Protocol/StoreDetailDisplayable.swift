//
//  StoreDetailDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI
import Combine

protocol StoreDetailDisplayable: AnyObject, ObservableObject {
    
    func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity
}
