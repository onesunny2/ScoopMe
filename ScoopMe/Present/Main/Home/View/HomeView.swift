//
//  HomeView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLocation
import SCMLogger
import CoreLocation

struct HomeView: View {
    
    @StateObject private var router = SCMRouter<HomePath>.shared
    @StateObject private var locationManager = DIContainer.shared.locationManager
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                Color.scmBrightSprout
                    .ignoresSafeArea()
            }
            .task {
                await locationManager.checkDeviceCondition()
            }
            .showAlert(
                isPresented: $locationManager.showAlert,
                title: "안내",
                message: locationManager.alertMessage, action: {
                    locationManager.openSettings()
                })
            .navigationDestination(for: HomePath.self) { router in
                switch router {
                case .detail: HomeDetailView()
                }
            }
            .toolbarItem (leading: {
                addressButton
            })
        }
    }
    
    private var addressButton: some View {
        Button {
            Log.debug("addressButton tapped")
        } label: {
            HStack(alignment: .center, spacing: 8) {
                Image(.location)
                    .basicImage(width: 24, color: .scmGray90)
                
                Text("\(locationManager.currentAddress)")
                    .basicText(.PTTitle3, .scmGray90)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
                
                Image(.detail)
                    .basicImage(width: 24, color: .scmGray90)
            }
        }
    }
}

#Preview {
    HomeView()
}
