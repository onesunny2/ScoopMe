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
    
    public let loginTokenManager: LoginTokenManager
    public let network: SCMNetworkImpl
    
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
