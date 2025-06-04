//
//  StoreDetailRepository.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import Foundation
import Combine
internal import SCMLogin
import SCMLogger
internal import SCMNetwork

public final class MockStoreDetailRepository: StoreDetailDisplayable {
    
    @Published public var showAlert: Bool = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    
    private let loginTokenManager: LoginTokenManager
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
    }
    
    public func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity {
        return StoreDetailInfoEntity(
            storeID: "Test",
            storeName: "원선 스쿱 베이커리",
            category: "베이커리",
            imageUrls: [
                Secret.baseURL + "/v1/data/stores/alan-hardman-SU1LFoeEUkk-unsplash_1747128644203.jpg",
                Secret.baseURL + "/v1/data/stores/chad-montano-MqT0asuoIcU-unsplash_1747128644346.jpg",
                Secret.baseURL + "/v1/data/stores/shourav-sheikh-a66sGfOnnqQ-unsplash_1747128644500.jpg"
            ],
            picchelinStatus: true,
            likeStatus: false,
            address: "서울시 스쿱구 원선20길 96, 730동",
            parkingInfo: "매장 건물 지하주차장",
            time: "매주 월~토 10:00 ~ 19:00",
            rating: "4.9",
            review: "(333)",
            distance: "2.2km",
            latitude: 0.0,
            longitude: 0.0
        )
    }
    
    public func getStoreDetailMenu(id: String) async throws -> DetailMenu {
        return ([
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
        ], [])
    }
    
    public func postStoreLikeStatus(store id: String, like status: Bool) async throws {
        
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
extension MockStoreDetailRepository {
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
