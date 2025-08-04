//
//  ProfileView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMImageRequest
import SCMLogger
import SCMLogin

struct ProfileView: View {
    
    @StateObject private var router = SCMRouter<ProfilePath>.shared
    @StateObject private var switcher = SCMSwitcher<MainFlow>.shared
    
    private let imageHelper: ImageHelper
    private let loginManager: LoginManager
    
    private let imageSize: CGFloat = 110
    private let strokeSize: CGFloat = 120
    
    @State private var logoutStatus = false
    @State private var logoutFailed = false
    
    init(
        imageHelper: ImageHelper,
        loginManager: LoginManager
    ) {
        self.imageHelper = imageHelper
        self.loginManager = loginManager
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
            .showAlert(
                isPresented: $logoutStatus,
                title: StringLiterals.logoutSuccessTitle.string,
                message: StringLiterals.logoutSuccessContent.string,
                action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        switcher.switchTo(.login)
                    }
                })
            .showAlert(
                isPresented: $logoutFailed,
                title: StringLiterals.logoutFailedTitle.string,
                message: StringLiterals.logoutFailedContent.string,
                multiAction: {
                    Task { await checkLogoutStatus() }
            })
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
                    Task {
                        await checkLogoutStatus()
                    }
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

// MARK: Action
extension ProfileView {
    private func checkLogoutStatus() async {
        let result = await loginManager.logout()
        
        if result {
            logoutStatus = true
        } else {
            logoutFailed = true
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case title = "프로필"
    case logout = "로그아웃"
    case logoutSuccessTitle = "로그아웃 성공"
    case logoutSuccessContent = "로그인 화면으로 돌아갑니다"
    case logoutFailedTitle = "로그아웃 실패"
    case logoutFailedContent = "로그아웃에 실패했습니다"
    
    var string: String {
        return self.rawValue
    }
}

#Preview {
    ProfileView(
        imageHelper: DIContainer.shared.imageHelper,
        loginManager: DIContainer.shared.loginManager
    )
}
