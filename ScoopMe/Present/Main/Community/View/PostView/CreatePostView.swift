//
//  CreatePostView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/31/25.
//

import SwiftUI
import SCMLogger

struct CreatePostView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let store: StoreBanner
    
    init(store: StoreBanner) {
        self.store = store
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                scoopInfoView
            }
            .padding(20)
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem(leading: {
                Text(StringLiterals.close.text)
                    .basicText(.PTBody1, .scmGray90)
                    .asButton {
                        dismiss()
                    }
            })
        }
    }
}

// MARK: UI
extension CreatePostView {
    
    // 스쿱 정보
    private var scoopInfoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(StringLiterals.scoopInfo.text)
                .basicText(.PTTitle6, .scmGray90)
            storeInfoBanner
        }
    }
    
    private var storeInfoBanner: some View {
        StoreInfoBannerCell(store: store)
    }

}

// MARK: String Literals
private enum StringLiterals: String {
    case navigationTitle = "작성하기"
    case close = "닫기"
    case scoopInfo = "스쿱 정보"
    case postTitle = "제목"
    case postContent = "포스트 내용"
    case mediaUpload = "사진/영상 업로드"
    case completeWrite = "작성 완료"
    
    var text: String {
        return self.rawValue
    }
}

//#Preview {
//    CreatePostView()
//}
