//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLocation

struct HomeView: View {
    
    private let locationManager = DIContainer.shared.locationManager
    
    var body: some View {
        Text("HomeView")
            .task {
                await locationManager.checkDeviceCondition()
            }
    }
}

#Preview {
    HomeView()
}
