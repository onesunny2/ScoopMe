//
//  OrderView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct OrderView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 0) {
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
    // 최상단 광고배너
    private var adBanners: some View {
        AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
    }
}

// MARK: Action
extension OrderView {
    
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "주문내역"
    case currentOrderTitle = "주문현황"
    case previousOrderTitle = "이전주문 내역"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    OrderView()
}
