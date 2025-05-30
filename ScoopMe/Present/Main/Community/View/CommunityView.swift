//
//  CommunityView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMCommunity
import SCMLogger

struct CommunityView: View {
    
    @State private var searchKeyword: String = ""
    @State private var volume: CGFloat = 0.3
    
    @State private var selectedFilter: TimelineFilter = .최신순
    
    var body: some View {
        NavigationStack {
            LazyVStack(spacing: 20) {
                SearchTextFieldCell(
                    placeholder: StringLiterals.placeholder.text,
                    keyword: $searchKeyword
                )
                
                distanceSliderCell
                timelineTitleAndFilter
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                }
            }
            .defaultHorizontalPadding()
            .navigationTitle(StringLiterals.navigationTitle.text)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarItem(trailing: {
                Image(.write)
                    .basicImage(width: 28, color: .scmBlackSprout)
                    .asButton {
                        Log.debug("⏭️ 글쓰기 버튼 클릭")
                    }
            })
        }
    }
}

// MARK: UI
extension CommunityView {
    
    private var distanceSliderCell: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(StringLiterals.distance.text + ": " + String(format: "%.2f", volume) + "km")
                .basicText(.PTBody4, .scmBlackSprout)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4).fill(.scmGray15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.scmBlackSprout, lineWidth: 0.5)
                        }
                )
                .animation(nil, value: volume)
            
            ExpendableSliderCell(value: $volume, in: 0...1) {
                HStack {
                    Image(.distance)
                        .basicImage(width: 24, color: .scmBrightSprout)
                    
                    Spacer()
                }
                .defaultHorizontalPadding()
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.scmGray45, lineWidth: 1)
        )
    }
    
    private var timelineTitleAndFilter: some View {
        HStack(alignment: .center) {
            Text(StringLiterals.timelineTitle.text)
                .basicText(.PTTitle4, .scmGray90)
            
            Spacer()
            
            // TODO: repostory 생기면 변경필요
            HStack(alignment: .center, spacing: 4) {
                Text(selectedFilter.text)
                    .basicText(.PTCaption1, .scmBlackSprout)
                Image(.list)
                    .basicImage(width: 16, color: .scmBlackSprout)
            }
            .asButton {
                switch selectedFilter {
                case .최신순: selectedFilter = .좋아요순
                case .좋아요순: selectedFilter = .최신순
                @unknown default:
                    selectedFilter = .최신순
                }
            }
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case navigationTitle = "스쿱미 소식통"
    case placeholder = "검색어를 입력해주세요."
    case timelineTitle = "타임라인"
    case distance = "범위"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    CommunityView()
}
 
