//
//  LoginSecureFieldCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/11/25.
//

import SwiftUI

struct LoginSecureFieldCell: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        SecureField("", text: $text)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .placeholder(placeholder, $text)
            .padding(15)
            .background(alignment: .center) {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.scmGray60.opacity(0.6))
            }
    }
}

#Preview {
    LoginSecureFieldCell(text: .constant(""), placeholder: "placeHolder")
}
