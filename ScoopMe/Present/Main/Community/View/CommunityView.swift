//
//  CommunityView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI

struct CommunityView: View {
    
    @State private var volume: CGFloat = 0.3
    
    var body: some View {
        NavigationStack {
            VStack {
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
                .defaultHorizontalPadding()
            }
            .navigationTitle("스쿱미 커뮤니티")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CommunityView()
}
 
