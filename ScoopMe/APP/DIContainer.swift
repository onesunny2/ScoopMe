//
//  DIContainer.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/18/25.
//

import Foundation
import Combine
import SCMLogger
import SCMLogin
import SCMLocation
import SCMScoopInfo

final class DIContainer {
    static let shared: DIContainer = DIContainer()
    
    private init() {
        self.loginManager = LoginManager()
        self.signUpManager = SignUpManager()
        self.loginTokenManager = LoginTokenManager()
        self.deviceTokenManager = DeviceTokenManager()
        
        self.locationManager = LocationManager()
        
        let repo = MockFoodCategoryRepository()
        self.foodCategoryRepository = AnyFoodCategoryDisplayable(repo)
    }
    
    /// SCMLogin
    private(set) var loginManager: LoginManager
    private(set) var signUpManager: SignUpManager
    private(set) var loginTokenManager: LoginTokenManager
    private(set) var deviceTokenManager: DeviceTokenManager
    
    /// SCMLocation
    private(set) var locationManager: LocationManager
    
    /// SCMScoopInfo
    private(set) var foodCategoryRepository: AnyFoodCategoryDisplayable
}
