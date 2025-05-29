//
//  CommunityView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct CommunityView: View {
    
    @State private var searchKeyword: String = ""
    @State private var volume: CGFloat = 0.3
    
    var body: some View {
        NavigationStack {
            LazyVStack(spacing: 20) {
                SearchTextFieldCell(
                    placeholder: StringLiterals.placeholder.text,
                    keyword: $searchKeyword
                )
                
                ExpendableSliderCell(value: $volume, in: 0...1) {
                    HStack {
                        Image(.distance)
                        
                        Spacer()
                        
                        Text(String(format: "%.2f", volume) + "km")
                            .font(.callout)
                            .animation(nil, value: volume)
                    }
                    .defaultHorizontalPadding()
                }
            }
            .defaultHorizontalPadding()
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "스쿱미 소식통"
    case placeholder = "검색어를 입력해주세요."
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    CommunityView()
}
 
