//
//  LoginManager.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import Foundation
import SCMNetwork

final class LoginManager {
    
    static let shared = LoginManager()
    private init() {
        self.network = SCMNetworkImpl()
    }
    
    private let network: SCMNetworkImpl
    
    func postAppleLogin(_ token: String) async {
        do {
            
            let value = LoginURL.appleLogin(id: token, device: nil, nick: "sunny")
            
            let request = HTTPRequest(
                scheme: .http,
                method: .post,
                successCodes: [200]
            )
                .addBaseURL(value.baseURL)
                .addPath(value.path)
                .addParamters(value.parameters)
                .addHeaders(value.headers)
            
            let result = try await network.fetchData(request, LoginDTO.self)
            
            Log.debug("appleLogin 결과: ", result)
            
        } catch {
            Log.error("login error: \(error)")
        }
    }
}
