//
//  PaymentRepository.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

public final class PaymentRepository: PaymentDisplayable {
    
    private let loginTokenManager: LoginTokenManager
    private let network: SCMNetworkImpl
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func getOrderCode(orderList: OrderList) async throws -> String {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let orderList: OrderList = orderList
        let value = PaymentURL.orders(access: accessToken, orderList: orderList)
        let result = try await callRequest(value, type: OrderCreateResponseDTO.self)
        
        return result.response.order_code
    }
    
    public func checkPaymentValidation(impUid: String) async throws -> String {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = PaymentURL.paymentValidation(access: accessToken, impUid: impUid)
        let result = try await callRequest(value, type: ReceiptOrderResponseDTO.self)
        
        Log.debug("🔗 결제 검증 완료")
        
        return result.response.orderItem.orderCode
    }
}

extension PaymentRepository {
    
    private func callRequest<T: Decodable>(_ value: PaymentURL, type: T.Type) async throws -> HTTPResponse<T> {
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
            // TODO: 만료되면 로그인 화면으로 돌아가도록 처리 필요
        }
    }
}
