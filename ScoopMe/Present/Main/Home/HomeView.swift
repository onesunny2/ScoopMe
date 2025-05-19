//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLocation

struct HomeView: View {
    
    @StateObject private var locationManager = DIContainer.shared.locationManager
    
    var body: some View {
        testButton
            .task {
                await locationManager.checkDeviceCondition()
            }
            .showAlert(
                isPresented: $locationManager.showAlert,
                title: "안내",
                message: locationManager.alertMessage, action: {
                    locationManager.openSettings()
                })
    }
    
    private var testButton: some View {
        Button {
            Task {
                await locationManager.startCurrentLocation()
            }
        } label: {
            Text("\(locationManager.currentLocation)")
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    HomeView()
}
