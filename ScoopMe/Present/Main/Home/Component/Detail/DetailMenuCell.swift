//
//  DetailMenuCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/27/25.
//

import SwiftUI
import SCMScoopInfo

struct DetailMenuCell: View {
    
    @Namespace private var countButtonID

    @State private var isSelectedMenu: Bool = false
    @State private var currentCount: Int = 0
    
    @Binding var selectedCount: Int
    @Binding var selectedPrice: Int
    
    let menu: StoreDetailMenuEntity
    
    var body: some View {
        HStack(alignment: .bottom) {
            textInfos
            
            Spacer(minLength: 34)
            
            menuImage
        }
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private var hashTag: some View {
        if let tag = menu.hashTag {
            Text(tag)
                .basicText(.PTCaption2, .scmBlackSprout)
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.scmBrightSprout)
                )
        }
    }
    
    private var textInfos: some View {
        VStack(alignment: .leading, spacing: 8) {
            hashTag
            
            Text(menu.menuName)
                .basicText(.PTTitle3, .scmGray90)
            Text(menu.description)
                .basicText(.PTBody6, .scmGray60)
            Text(menu.price)
                .basicText(.PTTitle3, .scmGray90)
        }
    }
    
    private var menuImage: some View {
        NukeRequestImageCell(
            imageHelper: DIContainer.shared.imageHelper,
            url: menu.image,
            topLeading: 8,
            bottomLeading: 8,
            bottomTrailing: 8,
            topTrailing: 8
        )
        .frame(width: 90, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            if menu.soldoutStatus {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.scmGray90.opacity(0.6))
                    .frame(width: 90, height: 90)
                    .overlay(alignment: .center) {
                        Text("품절")
                            .basicText(.PTTitle3, .scmGray0)
                    }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if currentCount == 0 {
                Image(.plus)
                    .basicImage(width: 15, color: .scmGray90)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.scmGray15)
                            .matchedGeometryEffect(id: "countButton", in: countButtonID)
                    )
                    .padding([.trailing, .bottom], 4)
                    .asButton {
                        withAnimation(.spring) {
                            currentCount += 1
                        }
                    }
            } else {
                menuCountButton
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var menuCountButton: some View {
        HStack(alignment: .center) {
            Image(.minus)
                .basicImage(width: 15, color: .scmGray90)
                .asButton {
                    withAnimation(.spring) {
                        currentCount -= 1
                    }
                }
            
            Spacer()
            
            Text("\(currentCount)")
                .basicText(.PTBody2, .scmGray90)
            
            Spacer()
            
            Image(.plus)
                .basicImage(width: 15, color: .scmGray90)
                .asButton {
                    withAnimation(.spring) {
                        currentCount += 1
                    }
                }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.scmGray15)
                .matchedGeometryEffect(id: "countButton", in: countButtonID)
        )
        .padding([.horizontal, .bottom], 4)
    }
}

//#Preview {
//    DetailMenuCell(menu: StoreDetailMenuEntity(
//        menuID: "68231f4cca81ef0db5a46161",
//        category: "카테고리 3", // 변경됨
//        menuName: "새싹 커피 6",
//        description: "맛있는 빵맛있는 빵맛있는 빵맛있는 빵맛있는 빵맛있는 빵맛있는 빵맛있는 빵맛있는 빵",
//        image: "/data/menus/1747131234960.jpg",
//        price: "10,500원",
//        hashTag: "인기 1위",
//        soldoutStatus: true
//    ))
//}
