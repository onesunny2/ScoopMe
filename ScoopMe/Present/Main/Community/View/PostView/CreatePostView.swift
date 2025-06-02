//
//  CreatePostView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/31/25.
//

import SwiftUI

struct CreatePostView: View {
    var body: some View {
        NavigationStack {
            Text("CreatePostView")
                .navigationTitle(StringLiterals.navigationTitle.text)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarItem {
                    Text(StringLiterals.close.text)
                        .basicText(.PTBody1, .scmGray90)
                } trailing: {
                    Text(StringLiterals.upload.text)
                        .basicText(.PTBody1, .scmGray90)
                }
        }
    }
}

// MARK: String Literals
private enum StringLiterals: String {
    case navigationTitle = "작성하기"
    case close = "닫기"
    case upload = "올리기"
    
    var text: String {
        return self.rawValue
    }
}

#Preview {
    CreatePostView()
}
