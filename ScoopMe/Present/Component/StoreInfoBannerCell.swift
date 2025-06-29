//
//  StoreInfoBannerCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/2/25.
//

import SwiftUI

struct StoreInfoBannerCell: View {
    
    private let store: StoreBanner
    
    init(store: StoreBanner) {
        self.store = store
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            NukeRequestImageCell(
                imageHelper: DIContainer.shared.imageHelper,
                url: store.imageUrl,
                topLeading: 8,
                bottomLeading: 8,
                bottomTrailing: 0,
                topTrailing: 0
            )
            .frame(width: 65, height: 65)
            .clippedUnevenRectangle(8, 8, 0, 0)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(store.name)
                    .basicText(.PTBody3, .scmBlackSprout)
                Text(store.detail)
                    .basicText(.PTCaption1, .scmDeepSprout)
            }
            .frame(maxWidth: .infinity, maxHeight: 65, alignment: .leading)
            .padding(.horizontal, 10)
            .background(
                UnevenRoundedRectangle(bottomTrailingRadius: 8, topTrailingRadius: 8)
                    .fill(.scmBrightSprout)
            )
        }
    }
}
