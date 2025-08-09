//
//  ExpendableTextView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 8/5/25.
//

import SwiftUI

struct ExpandableTextView: View {
    let text: String
    let lineLimit: Int
    let font: Font
    let color: Color
    
    @State private var isExpanded = false
    @State private var isTruncated = false
    
    init(
        text: String,
        lineLimit: Int = 3,
        font: Font = .PTBody5,
        color: Color = .scmGray75
    ) {
        self.text = text
        self.lineLimit = lineLimit
        self.font = font
        self.color = color
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(font)
                .foregroundColor(color)
                .lineLimit(isExpanded ? nil : lineLimit)
                .background(
                    // 텍스트가 잘렸는지 확인하기 위한 백그라운드 뷰
                    Text(text)
                        .font(font)
                        .lineLimit(lineLimit)
                        .background(GeometryReader { geometry in
                            Color.clear.onAppear {
                                let boundingRect = text.boundingRect(
                                    with: CGSize(width: geometry.size.width, height: CGFloat.greatestFiniteMagnitude),
                                    options: .usesLineFragmentOrigin,
                                    attributes: [.font: UIFont.systemFont(ofSize: 17)],
                                    context: nil
                                )
                                
                                let truncatedRect = text.boundingRect(
                                    with: CGSize(width: geometry.size.width, height: CGFloat(lineLimit) * 20), // 대략적인 라인 높이
                                    options: .usesLineFragmentOrigin,
                                    attributes: [.font: UIFont.systemFont(ofSize: 17)],
                                    context: nil
                                )
                                
                                isTruncated = boundingRect.height > truncatedRect.height
                            }
                        })
                        .hidden()
                )
            
            if isTruncated && !isExpanded {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded = true
                        }
                    }) {
                        Text("더보기")
                            .font(font)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    ExpandableTextView(text: "ddfdf\ndfsdfdf\nfgfhwagefsd\nfdfdfsdf\ndfdgrh", lineLimit: 3, font: .system(size: 16), color: .primary)
}
