//
//  OrderView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLogger
import SCMPayment

struct OrderView: View {
    
    private let paymentRepository: PaymentDisplayable
    @State private var orderStatusEntity: [OrderStatusEntity] = []
    @State private var previousOrderEntity: [PreviousOrderEntity] = []
    
    init(paymentRepository: PaymentDisplayable) {
        self.paymentRepository = paymentRepository
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    if !orderStatusEntity.isEmpty {
                        orderDashboard
                    }
                    adBanners
                    previousOrderDashboard
                }
            }
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await getOrderStatusEntity()
            }
        }
    }
}

// MARK: UI
extension OrderView {
    
    // 상단 주문현황
    private var orderDashboard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(StringLiterals.currentOrderTitle.text)
                .basicText(.PTTitle4, .scmGray60)
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(orderStatusEntity, id: \.self) { order in
                    if order.currentStatus != .픽업완료 {
                        OrderStatusCell(
                            repository: paymentRepository,
                            entity: order,
                            onPickupCompleted: { completedOrderNum in
                                // 픽업완료된 주문을 배열에서 제거
                                removeCompletedOrder(orderNum: completedOrderNum)
                                // 이전 주문내역에 새롭게 추가
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    appendPickedUpOrder(order: order)
                                }
                            }
                        )
                        .shadow(color: .scmGray90.opacity(0.1), radius: 12, x: 0, y: 4)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
        .defaultHorizontalPadding()
        .background(Color.scmGray15)
    }
 
    // 중단 광고배너
    private var adBanners: some View {
        AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
    }
    
    // 이전주문내역
    private var previousOrderDashboard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(StringLiterals.previousOrderTitle.text)
                .basicText(.PTTitle4, .scmGray45)
            
            ForEach(previousOrderEntity, id: \.orderCode) { entity in
                PreviousOrderCell(entity: entity)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
        .defaultHorizontalPadding()
        .background(Color.scmGray0)
    }
}

// MARK: Action
extension OrderView {
    
    // 픽업 완료되지 않은 상태의 order Entity request
    private func getOrderStatusEntity() async {
        do {
            let entity = try await paymentRepository.requestAwaitingPickupOrderList()
            self.orderStatusEntity = entity.current
            self.previousOrderEntity = entity.previous
        } catch {
            Log.error("❎ 픽업 대기 중인 오더리스트 통신 실패: \(error)")
            // TODO: refresh 토큰 오류 났을 때 처리 필요
        }
    }
    
    // 픽업완료된 주문을 배열에서 제거
    private func removeCompletedOrder(orderNum: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            orderStatusEntity.removeAll { $0.orderCode == orderNum }
        }
        Log.debug("🗑️ 픽업완료된 주문 제거: \(orderNum)")
    }
    
    // 픽업완료된 주문을 이전주문내역에 추가
    private func appendPickedUpOrder(order: OrderStatusEntity) {
        
        let firstItemName = order.orderedMenus.first?.menuName ?? ""
        let itemsCount = order.orderedMenus.count
        
        let newPreviousOrder: PreviousOrderEntity = PreviousOrderEntity(
            orderCode: order.orderCode,
            storeName: order.storeName,
            storeImageURL: order.storeImageURL,
            pickedDate: Date().toKoreanDateString(),
            orderedItems: (itemsCount == 1) ? firstItemName : firstItemName + "외 \(itemsCount - 1)건",
            totalPrice: order.totalPrice + " >",
            review: nil
        )
        
        previousOrderEntity.insert(newPreviousOrder, at: 0)
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "주문내역"
    case currentOrderTitle = "주문현황"
    case orderNum = "주문번호"
    case showMore = "주문내역 확인"
    case arrow = "▼"
    case previousOrderTitle = "이전주문 내역"
    case priceTitle = "결제금액"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    OrderView(paymentRepository: DIContainer.shared.paymentRepository)
}
