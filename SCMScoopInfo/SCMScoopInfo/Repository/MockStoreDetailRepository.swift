//
//  StoreDetailRepository.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/26/25.
//

import Foundation
internal import SCMLogin
import SCMLogger
internal import SCMNetwork

public class MockStoreDetailRepository: StoreDetailDisplayable {
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private let loginTokenManager: LoginTokenManager
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
    }
    
    public func getStoreDetailInfo(id: String) async throws -> StoreDetailInfoEntity {
        return StoreDetailInfoEntity(
            storeID: "Test",
            storeName: "원선 스쿱 베이커리",
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
            distance: "2.2km"
        )
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
                default: break
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
