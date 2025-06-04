//
//  MediaItemView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/3/25.
//

import SwiftUI
import SCMLogger

struct MediaItemView: View {
    
    let item: PostMediaItem
    let onDelete: () -> Void
    
    var body: some View {
        if let image = item.image, item.isImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 68, height: 68)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(alignment: .topTrailing) {
                    Image(.xmarkCircleFill)
                        .basicImage(width:20, color: .scmGray90)
                        .padding([.top, .trailing], 4)
                        .asButton {
                            Log.debug("⏭️ 지우기버튼 클릭")
                            onDelete()
                        }
                }
                .id(item.itemIdentifier)
        }
    }
}
