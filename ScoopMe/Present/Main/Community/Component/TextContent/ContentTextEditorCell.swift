//
//  ContentTextEditorCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/3/25.
//

import SwiftUI

struct ContentTextEditorCell: View {
    
    @Binding var contentText: String
    let placeholder: String
    
    var body: some View {
        TextEditor(text: $contentText)
            .foregroundStyle(.scmGray90)
            .font(.PTBody2)
            .lineSpacing(4)
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.scmGray60, lineWidth: 0.5)
            )
            .overlay(alignment: .topLeading) {
                if contentText.isEmpty {
                    Text(placeholder)
                        .basicText(.PTBody2, .scmGray60)
                        .padding(.top, 16)
                        .padding(.leading, 12)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Text("\(contentText.count) / 300")
                    .basicText(.PTBody2, (contentText.count <= 300) ? .scmGray60 : .red)
                    .padding([.trailing, .bottom], 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .onChange(of: contentText) { newText in
                if newText.count > 300 {
                    contentText = String(newText.prefix(300))
                }
            }
    }
}
