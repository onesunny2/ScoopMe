//
//  PopularKeywordCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI
import SCMLogin
import SCMLogger
import SCMNetwork
import SCMScoopInfo

struct PopularKeywordCell: View {
    
    @ObservedObject var foodCategoryRepository: AnyFoodCategoryDisplayable
    @ObservedObject var loginTokenManager: LoginTokenManager
    
    @State private var keywords: [String] = []
    @State private var keywordIndex: Int = 0
    @State private var timer: Timer? = nil
    
    @Binding var showAlert: Bool
    
    var body: some View {
        popularKeywords
            .task {
                await getPopularKeywords()
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .onChange(of: keywords) { newKeywords in
                if !newKeywords.isEmpty {
                    keywordIndex = 0
                    startTimer()
                } else {
                    stopTimer()
                }
            }
    }
    
    private var popularKeywords: some View {
        HStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 2) {
                Image(.default)
                    .basicImage(width: 12, color: .scmDeepSprout)
                Text(StringLiterals.popularKeywordTitle.text)
                    .basicText(.PTCaption1, .scmDeepSprout)
            }
            
            Text(currentPopularKeyword())
                .basicText(.PTCaption1, .scmBlackSprout)
                .transition(.push(from: .bottom).combined(with: .opacity))
                .id("keyword_\(keywordIndex)")
        }
    }
}

// MARK: method
extension PopularKeywordCell {
    
    private func getPopularKeywords() async {
        do {
            let result = try await foodCategoryRepository.getPopularKeywords()
            self.keywords = result
            
        } catch {
            await checkTokenValidation(error)
        }
    }
    
    private func checkTokenValidation(_ error: Error) async {
        if let scmError = error as? SCMError {
            switch scmError {
            case .serverError(let statusCode, _):
                switch statusCode {
                case 419: // access 만료 -> refresh 통신 진행
                    Log.debug("✅ accessToken만료")
                    await checkRefreshToken()
                case 401, 418: // refresh 토큰 오류 및 만료 -> 로그인 화면으로 보내기
                    loginTokenManager.alertTitle = "안내"
                    loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
                    showAlert = true
                default: break
                }
            default: break
            }
        }
    }
    
    private func checkRefreshToken() async {
        do {
            try await loginTokenManager.requestRefreshToken()
        } catch {
            loginTokenManager.alertTitle = "안내"
            loginTokenManager.alertMessage = "세션이 만료되었습니다. 다시 로그인해주세요."
            showAlert = true
        }
    }
    
    /// 인기검색어 세팅
    private func updateKeywordIndex() async {
        await MainActor.run {
            withAnimation(.easeInOut(duration: 0.3)) {
                if keywordIndex < keywords.count - 1 {
                    keywordIndex += 1
                } else {
                    keywordIndex = 0
                }
            }
        }
    }
    
    private func currentPopularKeyword() -> String {
        return "\(keywordIndex + 1).  \(keywords[at: keywordIndex])"
    }
    
    /// 타이머
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            Task {
                await updateKeywordIndex()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

private enum StringLiterals: String {
    case popularKeywordTitle = "인기검색어"
    
    var text: String {
        return self.rawValue
    }
}

