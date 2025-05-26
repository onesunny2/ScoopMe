//
//  StoreDetailDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI
import Combine

public protocol StoreDetailDisplayable: AnyObject, ObservableObject {
    
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    var menuSections: [String] { get set }
    
    func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity
    func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async
}
