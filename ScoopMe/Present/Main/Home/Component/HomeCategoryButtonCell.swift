//
//  HomeCategoryButtonCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

struct HomeCategoryButtonCell: View {
    
    let image: Image
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            rectangleImage
            categoryText
        }
    }
    
    private var rectangleImage: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(.scmGray0)
            .frame(width: 56, height: 56)
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? .scmBlackSprout : .scmGray45,
                        lineWidth: isSelected ? 2 : 1
                    )
                    .frame(width: 56, height: 56)
            }
            .overlay(alignment: .center) {
                image
                    .basicImage(width: 32)
            }
    }
    
    private var categoryText: some View {
        Text(title)
            .basicText(
                isSelected ? .PTBody3 : .PTBody4,
                isSelected ? .scmBlackSprout :  .scmGray60
            )
    }
}

#Preview {
    HomeCategoryButtonCell(image: Image(.fastFood), title: "패스트푸드", isSelected: false)
}
