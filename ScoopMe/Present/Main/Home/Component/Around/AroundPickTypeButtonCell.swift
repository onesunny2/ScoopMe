//
//  AroundPickTypeButtonCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI

struct AroundPickTypeButtonCell: View {
    
    @Binding var isPicked: Bool
    let title: String
    let action: () -> ()
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(.checkmarkSquareFill)
                .basicImage(width: 16, color: isPicked ? .scmBlackSprout : .scmGray60)
            
            Text(title)
                .basicText(.PTCaption1, isPicked ? .scmBlackSprout : .scmGray60)
        }
        .asButton {
            action()
        }
    }
}

#Preview {
    AroundPickTypeButtonCell(isPicked: .constant(true), title: "픽슐랭") {
        print("button Tapped")
    }
}
