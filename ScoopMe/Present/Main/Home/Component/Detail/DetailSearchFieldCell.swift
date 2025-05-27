//
//  DetailSearchFieldCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/27/25.
//

import SwiftUI

struct DetailSearchFieldCell: View {
    @Binding var text: String
    @Binding var showTextfield: Bool
    let placeholder: String
    let namespaceId: Namespace.ID
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            HStack(spacing: 0) {
                Image(.search)
                    .basicImage(width: 16, color: .scmGray90)
                    .padding(.leading, 18)
                    .padding(.vertical, 8)
                
                TextField("", text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .placeholder(placeholder, $text)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
            }
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(.scmGray30)
                    .matchedGeometryEffect(id: "search", in: namespaceId)
            )
            
            
            Text("닫기")
                .basicText(.PTBody1, .scmGray90)
                .asButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showTextfield = false
                    }
                }
                .padding(.leading, 8)
        }
    }
}

//#Preview {
//    DetailSearchFieldCell(text: .constant(""), showTextfield: .constant(true), placeholder: "")
//}
