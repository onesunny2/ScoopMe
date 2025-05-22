//
//  PopularKeywordCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

struct PopularKeywordCell: View {
    
    @State private var keywordIndex: Int = 0
    @State private var timer: Timer? = nil
    
    private let testPopulars: [String] = [
        "새싹 베이커리",
        "달콤 카페",
        "새싹 치킨 도봉점"
    ]
    
    var body: some View {
        popularKeywords
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
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
    /// 인기검색어 세팅
    private func updateKeywordIndex() async {
        await MainActor.run {
            withAnimation(.easeInOut(duration: 0.3)) {
                if keywordIndex < testPopulars.count - 1 {
                    keywordIndex += 1
                } else {
                    keywordIndex = 0
                }
            }
        }
    }
    
    private func currentPopularKeyword() -> String {
        return "\(keywordIndex + 1).  \(testPopulars[keywordIndex])"
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

#Preview {
    PopularKeywordCell()
}
