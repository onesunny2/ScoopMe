//
//  HomeSearchField.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

struct HomeSearchFieldCell: View {
    
    let placeholder: String
    @Binding var keyword: String
    
    var body: some View {
        TextField("", text: $keyword)
            .foregroundStyle(.scmGray90)
            .font(.PTBody2)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .placeholder(placeholder, $keyword)
            .padding(.leading, 45)
            .padding(.trailing, 30)
            .padding(.vertical, 12)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 40)
                    .fill(.scmGray0)
            }
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 40)
                    .stroke(lineWidth: 2)
                    .foregroundStyle(.scmDeepSprout)
            }
            .overlay(alignment: .leading, content: {
                Image(.search)
                    .basicImage(width: 24, color: .scmBlackSprout)
                    .padding(.leading, 15)
            })
    }
}
