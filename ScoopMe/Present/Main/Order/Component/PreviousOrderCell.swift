//
//  PreviousOrderCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/17/25.
//

import SwiftUI
import SCMLogger
import SCMPayment

struct PreviousOrderCell: View {
    
    private let entity: PreviousOrderEntity
    
    init(entity: PreviousOrderEntity) {
        self.entity = entity
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            orderInfoView
            reviewButtonCell
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.scmGray30)
        }
    }
}

// MARK: UI
extension PreviousOrderCell {
    // 주문 정보
    private var orderInfoView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text(entity.storeName)
                    .basicText(.PTTitle7, .scmGray75)
                
                HStack(alignment: .center) {
                    Text(entity.orderCode)
                        .basicText(.PTCaption1, .scmGray60)
                    Text(entity.pickedDate)
                        .basicText(.PTCaption1, .scmGray45)
                }
                
                HStack(alignment: .center) {
                    Text(entity.orderedItems)
                        .basicText(.PTTitle4, .scmGray60)
                    Text(entity.totalPrice)
                        .basicText(.PTTitle4, .scmBlackSprout)
                        .asButton {
                            Log.debug("🔗 주문내역 보기 클릭")
                        }
                }
            }
            
            Spacer(minLength: 4)
            
            // 가게 이미지
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: entity.storeImageURL,
                topLeading: 8,
                bottomLeading: 8,
                bottomTrailing: 8,
                topTrailing: 8
            )
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // 리뷰버튼
    private var reviewButtonCell: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(Color.scmGray30)
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .center) {
                if let review = entity.review {
                    HStack(alignment: .center, spacing: 8) {
                        Image(.favoriteFill)
                            .basicImage(width: 20, color: .scmBrightForsythia)
                        Text(String(format: "%.1f", review.rating))
                            .basicText(.PTBody1, .scmGray75)
                    }
                } else {
                    Text(stringLiterals.requiredReview.text)
                        .basicText(.PTBody1, .scmGray75)
                }
            }
            .asButton({
                Log.debug("🔗 리뷰 작성하기 버튼 클릭")
            }, disabled: entity.review != nil)
    }
}

// MARK: StringLiterals
private enum stringLiterals: String {
    case requiredReview = "리뷰 작성하기"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    let entity: PreviousOrderEntity = PreviousOrderEntity(
        orderCode: "A7701",
        storeName: "배고픈 이원선",
        storeImageURL: "",
        pickedDate: "2025년 4월 16일 오후 2:10",
        orderedItems: "얼그레이 새싹티 외 1건",
        totalPrice: "42,000원 >",
        review: /*Review(id: "", rating: 4.5)*/ nil
    )
    
    PreviousOrderCell(entity: entity)
        .defaultHorizontalPadding()
}
