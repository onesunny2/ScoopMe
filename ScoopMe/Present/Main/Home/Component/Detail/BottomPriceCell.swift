//
//  BottomPriceCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/27/25.
//

import SwiftUI

struct BottomPriceCell: View {
    
    let count: Int
    let price: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            countView
            
            Text("|")
                .basicText(.PTBody6, .scmGray15)
            
            Text("\(price.formatted()) 원")
                .basicText(.PTTitle4, .scmGray15)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.scmBlackSprout)
    }
    
    private var countView: some View {
        HStack(alignment: .center, spacing: 4) {
            Text("결제하기")
                .basicText(.PTTitle4, .scmGray15)
            
            Text("\(count)")
                .basicText(.PTBody3, .scmBlackSprout)
                .padding(5)
                .background(
                    Circle()
                        .fill(.scmGray15)
                )
        }
    }
}

#Preview {
    BottomPriceCell(count: 2, price: 200000)
}
