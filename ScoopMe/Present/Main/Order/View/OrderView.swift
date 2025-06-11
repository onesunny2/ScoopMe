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
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    orderDashboard
                    adBanners
                }
            }
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: UI
extension OrderView {
    
    // 상단 주문현황
    private var orderDashboard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack {
                Text(StringLiterals.currentOrderTitle.text)
                    .basicText(.PTTitle4, .scmGray60)
                Spacer()
            }
            
            orderStatus(order: dummyOrderStatus)
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
        .defaultHorizontalPadding()
        .background(Color.scmGray15)
    }
    
    private func orderStatus(order status: OrderStatusEntity) -> some View {
        HStack(alignment: .center, spacing: 0) {
            leftOrderInfo(order: status)
            Spacer(minLength: 20)
            rightOrderInfo(order: status)
        }
        .padding([.top, .horizontal], 20)
        .padding(.bottom, 40)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.scmGray0)
        }
        .overlay(alignment: .bottom) {
            UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
                .fill(Color.scmBrightSprout)
                .frame(height: 28)
                .overlay(alignment: .center) {
                    HStack(alignment: .bottom, spacing: 2) {
                        Text(StringLiterals.showMore.text)
                            .basicText(.PTCaption4, .scmGray75)
                        Text(StringLiterals.arrow.text)
                            .basicText(.PTCaption5, .scmGray75)
                    }
                }
                .asButton {
                    Log.debug("🔗 더보기 버튼 클릭")
                }
        }
    }
    
    // 좌상단 주문번호 및 가게 정보
    private func leftOrderInfo(order status: OrderStatusEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 4) {
                Text(StringLiterals.orderNum.text)
                    .basicText(.JNCaption1, .scmGray60)
                Text(status.orderNum)
                    .basicText(.JNCaption1, .scmDeepSprout)
            }
            .padding(.bottom, 8)
            
            Text(status.storeName)
                .basicText(.JNBody1, .scmBlackSprout)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 4)
            
            Text(status.orderDate)
                .basicText(.PTCaption2, .scmGray45)
                .padding(.bottom, 16)
            
            Image(.doughnut)
                .basicImage(width: 120)
        }
    }
    
    // 우상단 현재 주문진행상태
    private func rightOrderInfo(order status: OrderStatusEntity) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(status.currentOrder.indices, id: \.self) { index in
                orderCell(current: status.currentOrder[index])
                    .background(alignment: .topLeading, content: {
                        if (status.currentOrder.count - 1) != index {
                            Rectangle()
                                .fill(status.currentOrder[index].isCompleted ? Color.scmBlackSprout : .scmGray30)
                                .frame(width: 4, height: 22)
                                .padding(.leading, 6)
                                .padding(.top, 15)
                        }
                    })
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 18)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.scmGray15)
        }
    }
    
    private func orderCell(current order: CurrentStatus) -> some View {
        HStack(alignment: .center, spacing: 4) {
            Image(order.isCompleted ? .orderApproved : .orderAwait)
                .basicImage(width: 16)
                .padding(.trailing, 4)
            Text(order.orderType.text)
                .basicText(.PTCaption2, .scmGray90)
            Text(order.completedTime ?? "")
                .basicText(.PTCaption4, .scmGray60)
        }
    }
    
    // 중단 광고배너
    private var adBanners: some View {
        AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
    }
}

// MARK: Action

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "주문내역"
    case currentOrderTitle = "주문현황"
    case orderNum = "주문번호"
    case showMore = "주문내역 확인"
    case arrow = "▼"
    case previousOrderTitle = "이전주문 내역"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    OrderView()
}
