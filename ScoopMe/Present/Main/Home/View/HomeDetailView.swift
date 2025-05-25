//
//  HomeDetailView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/19/25.
//

import SwiftUI
import SCMScoopInfo

struct HomeDetailView: View {
    
    let storeID: String
    
    var body: some View {
        Text(storeID)
    }
}

#Preview {
    HomeDetailView(storeID: "storeID 예시")
}
