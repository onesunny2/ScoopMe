//
//  CurrentOrderEmptyView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/18/25.
//

import SwiftUI

struct CurrentOrderEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(.sesac)
                .basicImage(width: 60, color: .scmBrightSprout)
            
            Text("스쿱미를 시작해보세요!")
                .basicText(.JNTitle1, .scmBrightSprout)
            Text("모두의 편리한 픽업의 시작, ScoopMe")
                .basicText(.JNCaption1, .scmBrightSprout)
        }
    }
}

#Preview {
    CurrentOrderEmptyView()
}
