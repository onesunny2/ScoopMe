//
//  StoreDetailRepository.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/28/25.
//

import Foundation
import Combine
import CoreLocation
import SCMLocation
internal import SCMLogin
import SCMLogger
internal import SCMNetwork

public final class StoreDetailRepository: StoreDetailDisplayable {
    @Published public var showAlert: Bool = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    
    private let loginTokenManager: LoginTokenManager
    private let network: SCMNetworkImpl
    
    // 현재 위치 관련
    private let selectedAddressKey: String = "selectedAddress"
    private var currentLocation: CLLocation {
        let selectedAddress = UserDefaults.standard.fetchStruct(SavedLocation.self, for: selectedAddressKey)
        let location = CLLocation(
            latitude: selectedAddress?.latitude ?? 37.266710,
            longitude: selectedAddress?.longitude ?? 127.001148
        )
        return location
    }
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity {
        
        let result = try await getStoreDetailRequest(store: id)
        
        let place = CLLocation(latitude: result.geolocation.latitude, longitude: result.geolocation.longitude)
        let distance = currentLocation.distanceInKm(from: place)
        
        return StoreDetailInfoEntity(
            storeID: result.storeID,
            storeName: result.name,
            category: result.category,
            imageUrls: result.storeImageUrls.map { Secret.baseURL + "/v1" + $0 },
            picchelinStatus: result.isPicchelin,
            likeStatus: result.isPick,
            address: result.address,
            parkingInfo: result.parkingGuide,
            time: "\(result.open) ~ \(result.close)",
            rating: "\(result.totalRating)",
            review: "(\(result.totalReviewCount))",
            distance: distance,
            latitude: result.geolocation.latitude,
            longitude: result.geolocation.longitude
        )
    }
    
    public func getStoreDetailMenu(id: String) async throws -> DetailMenu {
        let result = try await getStoreDetailRequest(store: id)
        let menuList = result.menuList
        var menuEntity: [StoreDetailMenuEntity] = []
        var menuSections: [String] = []
        
        menuList.forEach {
            
            if !menuSections.contains($0.category) {
                menuSections.append($0.category)
            }
            
            let menu = StoreDetailMenuEntity(
                menuID: $0.menuID,
                category: $0.category,
                menuName: $0.name,
                description: $0.description,
                image: Secret.baseURL + "/v1" + $0.menuImageUrl,
                price: $0.price,
                priceString: $0.price.formatted() + "원",
                hashTag: $0.tags.first,
                soldoutStatus: $0.isSoldOut
            )
            
            menuEntity.append(menu)
        }
 
        return (menuEntity, menuSections)
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = ScoopInfoURL.postStoreLike(access: accessToken, storeID: id, status: status)
        let result = try await callRequest(value, type: LikeStoreResponseDTO.self)
        
        Log.debug("✅ 가게 좋아요 post 완료")
    }
    
    public func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async {
        if let scmError = error as? SCMError {
            switch scmError {
            case .serverError(let statusCode, _):
                switch statusCode {
                case 419: // access 만료 -> refresh 통신 진행
                    Log.debug("✅ accessToken만료")
                    await checkRefreshToken(complete: complete)
                case 401, 418: // refresh 토큰 오류 및 만료 -> 로그인 화면으로 보내기
                    loginTokenManager.alertTitle = "안내"
                    loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
                    showAlert = true
                default:
                    Log.error("❎ 서버통신 오류: \(error)")
                    break
                }
            default: break
            }
        }
    }
}

// MARK: private action
extension StoreDetailRepository {
    
    private func getStoreDetailRequest(store id: String) async throws -> StoreDetailResponseDTO {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = ScoopInfoURL.storeDetail(access: accessToken, storeID: id)
        let result = try await callRequest(value, type: StoreDetailResponseDTO.self)
        
        Log.debug("✅ 가게 상세정보 통신성공")
        
        return result.response
    }
    
    private func callRequest<T: Decodable>(_ value: ScoopInfoURL, type: T.Type) async throws -> HTTPResponse<T> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200]
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addParameters(value.parameters)
            .addJSONBody(value.jsonBody)
            .addHeaders(value.headers)
        
        return try await network.fetchData(request, T.self)
    }
    
    private func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            alertTitle = "안내"
            alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
            showAlert = true
        }
    }
}
