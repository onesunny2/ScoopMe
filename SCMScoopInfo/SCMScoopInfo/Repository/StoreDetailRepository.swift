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
    @Published public var menuSections: [String] = ["카테고리 1", "카테고리 2", "카테고리 3"]
    
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
            imageUrls: result.storeImageUrls.map { Secret.baseURL + "/v1" + $0 },
            picchelinStatus: result.isPicchelin,
            likeStatus: result.isPick,
            address: result.address,
            parkingInfo: result.parkingGuide,
            time: "\(result.open) ~ \(result.close)",
            rating: "\(result.totalRating)",
            review: "(\(result.totalReviewCount))",
            distance: distance
        )
    }
    
    public func getStoreDetailMenu(id: String) async throws -> [StoreDetailMenuEntity] {
        return [
            StoreDetailMenuEntity(
                menuID: "68231f4cca81ef0db5a46161",
                category: "카테고리 3", // 변경됨
                menuName: "새싹 커피 6",
                description: "맛있는 빵",
                image: Secret.baseURL + "/v1/data/menus/1747131234960.jpg",
                price: 10500,
                priceString: "10500",
                hashTag: "인기 1위",
                soldoutStatus: false
            ),
            StoreDetailMenuEntity(
                menuID: "68231f48ca81ef0db5a4615b",
                category: "카테고리 2",
                menuName: "새싹 커피 5",
                description: "맛있는 빵",
                image: Secret.baseURL + "/v1/data/menus/1747131234960.jpg",
                price: 10500,
                priceString: "10500",
                hashTag: nil,
                soldoutStatus: true
            ),
            StoreDetailMenuEntity(
                menuID: "68231f3eca81ef0db5a46155",
                category: "카테고리 2",
                menuName: "새싹 커피 4",
                description: "맛있는 빵",
                image: Secret.baseURL + "/v1/data/menus/1747131234960.jpg",
                price: 10500,
                priceString: "10500",
                hashTag: nil,
                soldoutStatus: true
            ),
            StoreDetailMenuEntity(
                menuID: "68231f36ca81ef0db5a4614f",
                category: "카테고리 3", // 변경됨
                menuName: "새싹 커피 3",
                description: "맛있는 빵",
                image: Secret.baseURL + "/v1/data/menus/1747131234960.jpg",
                price: 10500,
                priceString: "10500",
                hashTag: nil,
                soldoutStatus: false
            ),
            StoreDetailMenuEntity(
                menuID: "68231f28ca81ef0db5a46149",
                category: "카테고리 1",
                menuName: "새싹 커피 2",
                description: "맛있는 빵",
                image: Secret.baseURL + "/v1/data/menus/1747131234960.jpg",
                price: 10500,
                priceString: "10500",
                hashTag: nil,
                soldoutStatus: false
            ),
            StoreDetailMenuEntity(
                menuID: "68231f1dca81ef0db5a46143",
                category: "카테고리 1",
                menuName: "새싹 커피 1",
                description: "맛있는 빵",
                image: Secret.baseURL + "/v1/data/menus/1747131249732.jpg",
                price: 10500,
                priceString: "10500",
                hashTag: nil,
                soldoutStatus: false
            )
        ]
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
        
        Log.debug("✅ 가게 상세정보 통신성공: \(result.response)")
        
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
