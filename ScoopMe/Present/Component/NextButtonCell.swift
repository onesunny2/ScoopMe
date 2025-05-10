//
//  NextButtonCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

struct NextButtonCell: View {
    
    let title: String
    let buttonColor: Color
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 5)
            .fill(buttonColor)
            .frame(height: 50)
            .overlay(alignment: .center) {
                Text(title)
                    .basicText(.PTTitle1, .scmGray15)
            }
    }
}

#Preview {
    NextButtonCell(title: "로그인", buttonColor: .scmBlackSprout)
}
