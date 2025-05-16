//
//  NetworkServiceProtocol.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation
import Combine
import SCMLogger
internal import SCMNetwork

protocol NetworkServiceProtocol: ObservableObject, AnyObject {
    var network: SCMNetworkImpl { get }
    
    func fetchToken(_ type: Keychain) -> String
}

extension NetworkServiceProtocol {
    
    func fetchToken(_ type: Keychain) -> String {
        do {
            let keychainManager = KeychainManager()
            let token = try keychainManager.getToken(for: type)
            return token
        } catch {
            Log.error("\(type.rawValue)의 토큰 정보를 불러오는데 실패했습니다.")
            return ""
        }
    }
}
