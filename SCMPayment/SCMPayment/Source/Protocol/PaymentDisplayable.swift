//
//  PaymentDisplayable.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/11/25.
//

import Foundation
import SCMLogin
import SCMNetwork

public protocol PaymentDisplayable: AnyObject {
    typealias OrderCode = String
    typealias OrderEntities = (current: [OrderStatusEntity], previous: [PreviousOrderEntity])
    
    var network: SCMNetworkImpl { get }
    var loginTokenManager: LoginTokenManager { get }
    
    func getOrderCode(orderList: OrderList) async throws -> OrderCode
    func checkPaymentValidation(impUid: String) async throws -> OrderCode
    
    func callRequest<T: Decodable>(_ value: PaymentURL, type: T.Type) async throws -> HTTPResponse<T>
    func callEmptyRequest(_ value: PaymentURL) async throws -> HTTPResponse<EmptyResponse>
    func checkRefreshToken(complete: @escaping () async throws -> ()) async
    func requestAwaitingPickupOrderList() async throws -> OrderEntities
    func changeOrderStatus(order code: String, current status: OrderType) async throws -> OrderType
}

extension PaymentDisplayable {
    
    public func callRequest<T: Decodable>(_ value: PaymentURL, type: T.Type) async throws -> HTTPResponse<T> {
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
    
    public func callEmptyRequest(_ value: PaymentURL) async throws -> HTTPResponse<EmptyResponse> {
        let request = HTTPRequest(
            scheme: .http,
            method: value.method,
            successCodes: [200] // 200 OK
        )
            .addBaseURL(value.baseURL)
            .addPath(value.path)
            .addJSONBody(value.jsonBody)
            .addHeaders(value.headers)
        
        return try await network.fetchEmptyData(request)
    }
    
    public func checkRefreshToken(complete: @escaping () async throws -> ()) async {
        do {
            try await loginTokenManager.requestRefreshToken()
            try await complete()
        } catch {
            // TODO: 만료되면 로그인 화면으로 돌아가도록 처리 필요
        }
    }
}
