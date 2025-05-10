//
//  LoginTextFieldCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

struct LoginTextFieldCell: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField("", text: $text)
            .placeholder(placeholder, $text)
            .padding(20)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.scmGray60.opacity(0.6))
            }
    }
}

#Preview {
    LoginTextFieldCell(text: .constant(""), placeholder: "플레이스홀더")
}
