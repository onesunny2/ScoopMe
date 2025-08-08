//
//  CommentInputView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/7/25.
//

import SwiftUI
import SCMCommunity
import SCMLogger

struct CommentInputView: View {
    
    @Binding var textMessage: String
    var focusBinding: FocusState<Bool>.Binding
    var parentID: String?
    var tappedUpload: ((PostComment) -> Void)?
    var sendEditComment: (() -> Void)?
    
    @State private var textHeight: CGFloat = 0
    
    private let font = Font.custom(Font.Name.pretendardR.text, size: 16)
    private let lineHeight: CGFloat = 22 // 폰트 크기 16에 맞는 실제 라인 높이
    private let maxLines: Int = 3
    private let minHeight: CGFloat = 40
    private let horizontalPadding: CGFloat = 8
    private let verticalPadding: CGFloat = 8
    
    private var dynamicHeight: CGFloat {
        let baseHeight = max(textHeight, lineHeight) // 최소 1줄 높이 보장
        let totalHeight = baseHeight + (verticalPadding * 2)
        
        // 최소 높이와 최대 높이(3줄) 사이로 제한
        let maxAllowedHeight = CGFloat(maxLines) * lineHeight + (verticalPadding * 2)
        return max(minHeight, min(totalHeight, maxAllowedHeight))
    }
    
    private var cornerRadius: CGFloat {
        let currentLines = max(1, Int(ceil(textHeight / lineHeight)))
        return currentLines <= 1 ? 50 : 12
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 8) {
                // 채팅 입력영역
                TextEditor(text: $textMessage)
                    .font(font)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, verticalPadding)
                    .frame(height: dynamicHeight)
                    .background(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.scmGray15)
                    )
                    .focused(focusBinding)
                    .background(
                        // 텍스트 높이 측정을 위한 숨겨진 Text
                        Text(textMessage.isEmpty ? " " : textMessage)
                            .font(font)
                            .padding(.horizontal, horizontalPadding)
                            .fixedSize(horizontal: false, vertical: true)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            textHeight = geometry.size.height
                                        }
                                        .onChange(of: textMessage) { _ in
                                            DispatchQueue.main.async {
                                                textHeight = geometry.size.height
                                            }
                                        }
                                }
                            )
                            .opacity(0)
                    )
                
                // 전송 버튼
                Circle()
                    .fill(textMessage.isEmpty ? Color.scmGray15 : Color.scmBrightForsythia)
                    .frame(width: 40)
                    .overlay(alignment: .center) {
                        Image(.arrowUp)
                            .basicImage(width: 25, color: textMessage.isEmpty ? .scmGray60 : .scmGray90)
                    }
                    .asButton({
                        Log.debug("🔗 댓글 업로드 버튼 클릭")
                        
                        let comment = PostComment(parentID: parentID, content: textMessage)
                        tappedUpload?(comment)
                        
                        sendEditComment?()
                    }, disabled: textMessage.isEmpty)
            }
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.container, edges: .bottom)
    }
}
