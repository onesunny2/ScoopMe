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
    
    static public let shared = ImageHelper(cacheStrategies: [.MemoryCache, .AggressiveDiskCache])
    static public let imagePrefetcher = ImagePrefetcher(destination: .diskCache)
    
    private let tokenManager: LoginTokenManager
    
    init(
        isDecompressionEnabled: Bool = true,
        isTaskCoalescingEnabled: Bool = true,
        isResumableDataEnabled: Bool = true,
        isRateLimiterEnabled: Bool = true,
        isProgressiveDecodingEnabled: Bool = true,
        cacheStrategies: [CacheStrategy],
        memoryCacheLimit: Int = 100 * 1024 * 1024,
        diskCacheLimit: Int = 200 * 1024 * 1024,
        httpCacheMemoryLimit: Int = 50 * 1024 * 1024,
        httpCacheDiskLimit: Int = 150 * 1024 * 1024
    ) {
        
        self.tokenManager = LoginTokenManager()
        
        var configuration = ImagePipeline.shared.configuration
        configuration.isDecompressionEnabled = isDecompressionEnabled
        configuration.isTaskCoalescingEnabled = isTaskCoalescingEnabled
        configuration.isResumableDataEnabled = isResumableDataEnabled
        configuration.isRateLimiterEnabled = isRateLimiterEnabled
        
        configuration.isProgressiveDecodingEnabled = isProgressiveDecodingEnabled
        configuration.isStoringPreviewsInMemoryCache = isProgressiveDecodingEnabled
        
        guard !cacheStrategies.isEmpty else { return }
        
        // 메모리 캐시 설정
        if cacheStrategies.contains(.MemoryCache) {
            let imageCache = ImageCache()
            imageCache.costLimit = memoryCacheLimit
            imageCache.countLimit = 1000 // 최대 1000개 이미지
            configuration.imageCache = imageCache
        }
        
        // HTTP 캐시 및 디스크 캐시 설정
        let dataLoadConfiguration = DataLoader.defaultConfiguration
        
        if cacheStrategies.contains(.HTTPDiskCache) {
            let urlCache = URLCache(
                memoryCapacity: httpCacheMemoryLimit,
                diskCapacity: httpCacheDiskLimit,
                directory: nil
            )
            dataLoadConfiguration.urlCache = urlCache
        }
        
        configuration.dataLoader = DataLoader(configuration: dataLoadConfiguration)
        
        // Aggressive 디스크 캐시 설정
        if cacheStrategies.contains(.AggressiveDiskCache) {
            let dataCache = try? DataCache(name: "com.scoopme.dataCache")
            dataCache?.sizeLimit = diskCacheLimit
            configuration.dataCache = dataCache
        }
        
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
