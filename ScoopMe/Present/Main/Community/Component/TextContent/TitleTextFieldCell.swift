//
//  TitleTextFieldCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/3/25.
//

import SwiftUI

struct TitleTextFieldCell: View {
    
    @Binding var titleText: String
    let placeholder: String
    
    var body: some View {
        TextField("", text: $titleText)
            .foregroundStyle(.scmGray90)
            .font(.PTBody2)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .placeholder(placeholder, $titleText)
            .padding([.bottom, .leading], 8)
            .background(alignment: .bottom) {
                Rectangle()
                    .fill(.scmGray45)
                    .frame(height: 1)
            }
            .overlay(alignment: .trailing) {
                Text("\(titleText.count) / 15")
                    .basicText(.PTBody2, (titleText.count <= 15) ? .scmGray60 : .red)
                    .padding(.trailing, 8)
            }
            .onChange(of: titleText) { newText in
                if newText.count > 15 {
                    titleText = String(newText.prefix(15))
                }
            }
    }
}
