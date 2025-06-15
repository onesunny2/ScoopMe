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
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    // 결제에 사용될 오더코드 호출 통신
    public func getOrderCode(orderList: OrderList) async throws -> OrderCode {
        
        let orderList: OrderList = orderList
        let value = PaymentURL.orders(access: accessToken, orderList: orderList)
        let result = try await callRequest(value, type: OrderCreateResponseDTO.self)
        
        return result.response.order_code
    }
    
    // 결제 후 검증하는 호출 통신
    public func checkPaymentValidation(impUid: String) async throws -> OrderCode {
        
        let value = PaymentURL.paymentValidation(access: accessToken, impUid: impUid)
        let result = try await callRequest(value, type: ReceiptOrderResponseDTO.self)
        
        Log.debug("🔗 결제 검증 완료")
        
        return result.response.orderItem.orderCode
    }
    
    // 결제 완료된 아직 픽업 완료되지 않은 항목 통신
    public func requestAwaitingPickupOrderList() async throws -> [OrderStatusEntity] {
        
        let value = PaymentURL.requestAwaitingOrderList(access: accessToken)
        let result = try await callRequest(value, type: OrderListResponseDTO.self)
        let data = result.response.data
        
        Log.debug("🔗 픽업 대기 중인 오더리스트 통신 완료")
        
        var entities: [OrderStatusEntity] = []
        
        data.forEach {
            
            let currentStatus: [CurrentStatus] = $0.orderStatusTimeline.map {
                CurrentStatus(
                    orderType: OrderType(bodyQuery: $0.status) ?? .승인대기,
                    isCompleted: $0.completed,
                    completedTime: $0.changedAt?.toKoreanTime()
                )
            }
            
            // 주문한 메뉴
            let orderedMenus: [OrderedMenu] = $0.orderMenuList.map {
                OrderedMenu(
                    menuName: $0.menu.name,
                    quantity: Int($0.quantity),
                    stringQuantity: "\(Int($0.quantity))EA",
                    price: Int($0.quantity) * ($0.menu.price ?? 0),
                    stringPrice: (Int($0.quantity) * ($0.menu.price ?? 0)).formatted() + "원",
                    imageURL: Secret.baseURL + "/v1" + $0.menu.menuImageUrl
                )
            }
            
            let entity: OrderStatusEntity = OrderStatusEntity(
                orderNum: $0.orderCode,
                storeName: $0.store.name,
                storeImageURL: Secret.baseURL + "/v1" +  ($0.store.storeImageUrls.first ?? ""),
                orderDate: $0.paidAt.toKoreanDate(),
                currentOrder: currentStatus,
                orderedMenus: orderedMenus,
                totalQuantity: "\(orderedMenus.reduce(0) { $0 + $1.quantity })EA",
                totalPrice: "\($0.totalPrice.formatted())원"
            )
            
            entities.append(entity)
        }
        
        return entities
    }
}
