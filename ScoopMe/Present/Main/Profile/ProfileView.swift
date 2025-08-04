//
//  ProfileView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMImageRequest
import SCMLogger

struct ProfileView: View {
    
    @StateObject private var router = SCMRouter<ProfilePath>.shared
    
    private let imageHelper: ImageHelper
    
    private let imageSize: CGFloat = 110
    private let strokeSize: CGFloat = 120
    
    init(imageHelper: ImageHelper) {
        self.imageHelper = imageHelper
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmGray15
                    .ignoresSafeArea()
                
                VStack {
                    profileImageView
                    Spacer()
                    logoutButton
                }
                .padding(.top, 20)
            }
            .navigationTitle(StringLiterals.title.string)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var profileImageView: some View {
        Circle()
            .fill(.scmBrightSprout)
            .frame(width: strokeSize)
            .overlay(alignment: .center) {
                NukeRequestImageCell(
                    imageHelper: imageHelper,
                    url: "",
                    topLeading: imageSize / 2,
                    bottomLeading: imageSize / 2,
                    bottomTrailing: imageSize / 2,
                    topTrailing: imageSize / 2
                )
                .frame(width: imageSize, height: imageSize)
                .onTapGesture {
                    Log.debug("프로필 이미지 taptap")
                }
            }
    }
    
    private var logoutButton: some View {
        HStack(alignment: .center) {
            Rectangle()
                .fill(.scmGray60)
                .frame(height: 0.5)
            
            Text(StringLiterals.logout.string)
                .basicText(.PTBody2, .scmGray45)
                .asButton {
                    Log.debug("로그아웃 버튼 클릭")
                }
                .padding(.horizontal, 12)
            
            Rectangle()
                .fill(.scmGray60)
                .frame(height: 0.5)
        }
        .defaultHorizontalPadding()
        .padding(.bottom, 8)
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case title = "프로필"
    case logout = "로그아웃"
    
    var string: String {
        return self.rawValue
    }
}

#Preview {
    ProfileView(imageHelper: DIContainer.shared.imageHelper)
}
