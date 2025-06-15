//
//  OrderStatusCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/11/25.
//

import SwiftUI
import SCMLogger
import SCMPayment

struct OrderStatusCell: View {
    
    @Namespace private var namespace
    @State private var isShowMore: Bool = false
    
    private let entity: OrderStatusEntity
    
    init(entity: OrderStatusEntity) {
        self.entity = entity
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            orderStatus(order: entity)
            if isShowMore {
                orderHistory
            }
            showMoreButton
        }
        .background {
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16,
                topTrailingRadius: 16
            )
            .fill(Color.scmGray0)
            .matchedGeometryEffect(id: "unifiedBackground", in: namespace)
        }
        .animation(.easeInOut(duration: 0.3), value: isShowMore)
        .clippedUnevenRectangle(
            16, isShowMore ? 0 : 16, isShowMore ? 0 : 16, 16
        )
    }
}

// MARK: UI
extension OrderStatusCell {
    
    private func orderStatus(order status: OrderStatusEntity) -> some View {
        HStack(alignment: .center, spacing: 0) {
            leftOrderInfo
            Spacer(minLength: 20)
            rightOrderInfo
        }
        .padding(20)
    }
    
    // 좌상단 주문번호 및 가게 정보
    private var leftOrderInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 4) {
                Text(StringLiterals.orderNum.text)
                    .basicText(.JNCaption2, .scmGray60)
                Text(entity.orderNum)
                    .basicText(.JNCaption2, .scmDeepSprout)
            }
            .padding(.bottom, 8)
            
            Text(entity.storeName)
                .basicText(.JNBody1, .scmBlackSprout)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 4)
            
            Text(entity.orderDate)
                .basicText(.PTCaption2, .scmGray45)
                .padding(.bottom, 16)
            
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: entity.storeImageURL,
                topLeading: 5,
                bottomLeading: 5,
                bottomTrailing: 5,
                topTrailing: 5
            )
            .frame(width: 132, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(alignment: .bottomTrailing) {
                Image(.sesac)
                    .basicImage(width: 25, color: .scmBrightSprout)
                    .padding([.trailing, .bottom], 4)
                    .asButton {
                        Log.debug("🔗 주문 다음 단계로!")
                    }
            }
        }
    }
    
    // 우상단 현재 주문진행상태
    private var rightOrderInfo: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(entity.currentOrder.indices, id: \.self) { index in
                orderCell(current: entity.currentOrder[index])
                    .background(alignment: .topLeading, content: {
                        if (entity.currentOrder.count - 1) != index {
                            Rectangle()
                                .fill(entity.currentOrder[index].isCompleted ? Color.scmBlackSprout : .scmGray30)
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
    
    // 주문한 메뉴 내역
    private var orderHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(entity.orderedMenus, id: \.menuName) { menu in
                VStack(alignment: .leading, spacing: 12) {
                    menuCell(orderd: menu)
                    
                    Rectangle()
                        .fill(Color.scmGray30)
                        .frame(maxWidth: .infinity, maxHeight: 0.5)
                        .padding(.trailing, 20)
                }
            }
            
            HStack(alignment: .center, spacing: 0) {
                Text(StringLiterals.priceTitle.text)
                    .basicText(.PTTitle4, .scmGray60)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 8) {
                    Text(entity.totalQuantity)
                        .basicText(.PTBody2, .scmGray60)
                    Text(entity.totalPrice)
                        .basicText(.PTBody2, .scmGray90)
                }
                .padding(.trailing, 20)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.leading, .top], 20)
        .padding(.bottom, 12)
    }
    
    private func menuCell(orderd menu: OrderedMenu) -> some View {
        HStack(alignment: .center, spacing: 16) {
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: menu.imageURL,
                topLeading: 8,
                bottomLeading: 8,
                bottomTrailing: 8,
                topTrailing: 8
            )
            .frame(width: 84, height: 52)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(menu.menuName)
                    .basicText(.PTTitle4, .scmGray90)
                HStack(alignment: .center, spacing: 8) {
                    Text(menu.stringPrice)
                        .basicText(.PTBody2, .scmGray75)
                    Text(menu.stringQuantity)
                        .basicText(.PTBody2, .scmGray60)
                }
            }
        }
    }
    
    // 주문내역 더보기 영역
    private var showMoreButton: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
            .fill(Color.scmBrightSprout)
            .frame(height: 28)
            .matchedGeometryEffect(id: "buttonBackground", in: namespace)
            .overlay(alignment: .center) {
                HStack(alignment: .bottom, spacing: 2) {
                    Text(isShowMore ? StringLiterals.showLess.text : StringLiterals.showMore.text)
                        .basicText(.PTCaption4, .scmGray75)
                    Text(isShowMore ? StringLiterals.arrowUp.text : StringLiterals.arrowDown.text)
                        .basicText(.PTCaption5, .scmGray75)
                }
            }
            .asButton {
                Log.debug("🔗 더보기 버튼 클릭")
                withAnimation(.easeInOut(duration: 0.3)) {
                    isShowMore.toggle()
                }
            }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case orderNum = "주문번호"
    case showMore = "주문내역 확인"
    case showLess = "접기"
    case arrowDown = "▼"
    case arrowUp = "▲"
    case priceTitle = "결제금액"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    ZStack {
        Color.scmGray90
        
        OrderStatusCell(entity: dummyOrderStatus.first!)
            .defaultHorizontalPadding()
    }
}
