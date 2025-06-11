//
//  DetailMenuCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/27/25.
//

import SwiftUI
import SCMLogger
import SCMScoopInfo
import SCMPayment

struct DetailMenuCell: View {
    
    @Namespace private var countButtonID

    @State private var isSelectedMenu: Bool = false
    
    @State private var selectedCount: Int = 0
    @State private var selectedPrice: Int = 0
    
    @Binding var selectedMenus: [OrderMenu]
    
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
            Text(menu.priceString)
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
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.scmGray45, lineWidth: 0.5)
        )
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
            if selectedCount == 0 && !menu.soldoutStatus {
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
                            selectedCount += 1
                            selectedPrice += menu.price
                            
                            appendOrderMenu()
                            
                            Log.debug("🔗 현재 선택된 메뉴 총 갯수: \(selectedMenus)")
                        }
                    }
            } else if selectedCount != 0 && !menu.soldoutStatus {
                menuCountButton
                    .padding([.horizontal, .bottom], 4)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var menuCountButton: some View {
        HStack(alignment: .center) {
            Image(.minus)
                .basicImage(width: 15, color: .scmGray90)
                .padding([.vertical, .leading], 6)
                .asButton {
                    withAnimation(.spring) {
                        selectedCount -= 1
                        selectedPrice -= menu.price
                        
                        appendOrderMenu()
                        
                        Log.debug("🔗 현재 선택된 메뉴 총 갯수: \(selectedMenus)")
                    }
                }
            
            Spacer()
            
            Text("\(selectedCount)")
                .basicText(.PTBody2, .scmGray90)
            
            Spacer()
            
            Image(.plus)
                .basicImage(width: 15, color: .scmGray90)
                .padding([.vertical, .trailing], 6)
                .asButton {
                    withAnimation(.spring) {
                        selectedCount += 1
                        selectedPrice += menu.price
                        
                        appendOrderMenu()
                        
                        Log.debug("🔗 현재 선택된 메뉴 총 갯수: \(selectedMenus)")
                    }
                }
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.scmGray15)
                .matchedGeometryEffect(id: "countButton", in: countButtonID)
        )
    }
}

// MARK: Action
extension DetailMenuCell {
    
    // 현재 메뉴 정보 배열에 담기
    private func appendOrderMenu() {
        
        let menu: OrderMenu = OrderMenu(
            menuID: menu.menuID,
            quantity: selectedCount,
            price: selectedPrice
        )
        
        if let index = selectedMenus.firstIndex(where: { $0.menuID == menu.menuID }) {
            if menu.quantity != 0 {
                selectedMenus.replaceSubrange(index...index, with: [menu])
            } else {
                selectedMenus.remove(at: index)
            }
        } else {
            selectedMenus.append(menu)
        }
    }
}
