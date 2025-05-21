//
//  ImageHelper.swift
//  SCMImageRequest
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI
import Nuke
import NukeUI
import SCMNetwork
import SCMLogger
import SCMLogin

public final class ImageHelper {
    
    static public let shared = ImageHelper()
    public init() {
        self.tokenManager = LoginTokenManager()
    }
    
    private let tokenManager: LoginTokenManager
    
    public func createImageRequest(image url: String) -> ImageRequest? {
        
        do {
            let accessToken = tokenManager.fetchToken(.accessToken)
            
            let scheme: Schemes = .http
            let headers = [
                "Authorization": accessToken,
                "SeSACKey": Secret.apiKey
            ]
            Log.debug("액세스: \(accessToken), 새싹키: \(Secret.apiKey)")
            let request = HTTPRequest(
                scheme: scheme,
                method: .get,
                successCodes: [200]
            )
                .addBaseURL(url)
                .addHeaders(headers)
                .setCachePolicy(.returnCacheDataElseLoad)
            
            let urlRequest = try request.urlRequest()
            Log.debug("urlRequest: \(urlRequest)")
            var imageRequest = ImageRequest(urlRequest: urlRequest)
            
            imageRequest.priority = .normal
            
            return imageRequest
            
        } catch {
            Log.error("이미지 생성 요청 실패: \(error)")
            return nil
        }
    }
    
    public func handleImageError(_ error: Error) -> SCMError {
        
        if let scmError = error as? SCMError { return scmError }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return SCMError.requestFailed(urlError)
            case .userAuthenticationRequired:
                return SCMError.serverError(statusCode: 419, message: "엑세스 토큰이 만료되었습니다.")
            case .badServerResponse:
                return SCMError.invalidResponse
            default:
                return SCMError.requestFailed(urlError)
            }
        }
        
        return SCMError.requestFailed(error)
    }
}
