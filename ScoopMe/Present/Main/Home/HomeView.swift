//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLocation
import CoreLocation

struct HomeView: View {
    
    @StateObject private var router = SCMRouter<HomePath>.shared
    @StateObject private var locationManager = DIContainer.shared.locationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
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
        }
    }
    
    private var testButton: some View {
        Button {
            Task {
                await locationManager.startCurrentLocation()
            }
        } label: {
            VStack {
                Text("\(locationManager.currentLocation.coordinate.latitude)")
                Text("\(locationManager.currentLocation.coordinate.longitude)")
                Text("주소: \(locationManager.currentAddress)")
            }
        }
    }
}

#Preview {
    HomeView()
}
