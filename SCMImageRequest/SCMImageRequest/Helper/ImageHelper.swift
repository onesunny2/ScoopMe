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
    
    private var pipeline = ImagePipeline.shared
    
    static public let shared = ImageHelper(cacheStragies: [.MemoryCache, .AggressiveDiskCache])
    static public let imagePrefetcher = ImagePrefetcher(destination: .diskCache)
    
    private let tokenManager: LoginTokenManager
    
    init(
        isDecompressionEnabled: Bool = true,
        isTaskCoalescingEnabled: Bool = true,
        isResumableDataEnabled: Bool = true,
        isRateLimiterEnabled: Bool = true,
        isProgressiveDecodingEnabled: Bool = true,
        cacheStragies: [CacheStrategy]) {
            
            self.tokenManager = LoginTokenManager()
            
            var configuration = ImagePipeline.shared.configuration
            configuration.isDecompressionEnabled = isDecompressionEnabled
            configuration.isTaskCoalescingEnabled = isTaskCoalescingEnabled
            configuration.isResumableDataEnabled = isResumableDataEnabled
            configuration.isRateLimiterEnabled = isRateLimiterEnabled
            
            configuration.isProgressiveDecodingEnabled = isProgressiveDecodingEnabled
            configuration.isStoringPreviewsInMemoryCache = isProgressiveDecodingEnabled
            
            guard !cacheStragies.isEmpty else { return }
            
            configuration.imageCache = cacheStragies.contains(.MemoryCache) ? ImageCache.shared : nil
            
            let dataLoadConfiguration = DataLoader.defaultConfiguration
            dataLoadConfiguration.urlCache = cacheStragies.contains(.HTTPDiskCache) ? DataLoader.sharedUrlCache : nil
            configuration.dataLoader = DataLoader(configuration: dataLoadConfiguration)
            configuration.dataCache = cacheStragies.contains(.AggressiveDiskCache) ? try? DataCache(name: "com.scoopme.dataCache") : nil
            
            self.pipeline = ImagePipeline(configuration: configuration)
        }
    
    private init() {
        self.tokenManager = LoginTokenManager()
    }
    
    public func createImageRequest(
        image url: String,
        imageSize: ImageSize = .medium,
        processors: [ImageProcessing] = []
    ) -> ImageRequest? {
        do {
            let accessToken = tokenManager.fetchToken(.accessToken)
            
            let scheme: Schemes = .http
            let headers = [
                "Authorization": accessToken,
                "SeSACKey": Secret.apiKey
            ]
            
            let request = HTTPRequest(
                scheme: scheme,
                method: .get,
                successCodes: [200]
            )
                .addBaseURL(url)
                .addHeaders(headers)
                .setCachePolicy(.returnCacheDataElseLoad)
            
            let urlRequest = try request.urlRequest()
            
            var imageRequest = ImageRequest(urlRequest: urlRequest)
            
            imageRequest.priority = .normal
            
            var finalProcessors: [ImageProcessing] = []
            if let size = imageSize.cgSize {
                finalProcessors.append(ImageProcessors.Resize(size: size))
            }
            
            finalProcessors.append(contentsOf: processors)
            imageRequest.processors = finalProcessors
            
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
