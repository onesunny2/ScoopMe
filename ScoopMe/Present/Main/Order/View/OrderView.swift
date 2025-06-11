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
    
    @State private var orderStatusEntity: [OrderStatusEntity] = dummyOrderStatus
    
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
        VStack(alignment: .leading, spacing: 16) {
            Text(StringLiterals.currentOrderTitle.text)
                .basicText(.PTTitle4, .scmGray60)
            
            VStack(alignment: .leading, spacing: 20) {
                ForEach(orderStatusEntity, id: \.self) { order in
                    OrderStatusCell(entity: order)
                        .shadow(color: .scmGray90.opacity(0.1), radius: 12, x: 0, y: 4)
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
    case priceTitle = "결제금액"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    OrderView()
}
