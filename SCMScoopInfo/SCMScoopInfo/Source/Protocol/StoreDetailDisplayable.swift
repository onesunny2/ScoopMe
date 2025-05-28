//
//  StoreDetailDisplayable.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI
import Combine

public protocol StoreDetailDisplayable: AnyObject, ObservableObject {
    typealias DetailMenu = (menu: [StoreDetailMenuEntity], section: [String])
    
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    
    func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity
    func getStoreDetailMenu(id: String) async throws -> DetailMenu
    func postStoreLikeStatus(store id: String, like status: Bool) async throws
    func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async
}
