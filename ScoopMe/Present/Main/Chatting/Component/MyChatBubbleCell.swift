//
//  MyChatBubbleCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/26/25.
//

import SwiftUI

struct MyChatBubbleCell: View {
    
    private let sendDate: String
    private let message: String
    
    init(sendDate: String, message: String) {
        self.sendDate = sendDate
        self.message = message
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Spacer(minLength: 4)
            
            Text(sendDate)
                .basicText(.PTBody5, .scmGray90)
            Text(message)
                .basicText(.PTTitle8, .scmGray100)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.scmDeepSprout)
                }
        }
    }
}

#Preview {
    MyChatBubbleCell(sendDate: "오후 10:51", message: "여기는 지금 비 안오는데 거기는 오고 있어?")
}
