//
//  DIContainer.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/18/25.
//

import Foundation
import SCMCommunity
import SCMImageRequest
import SCMLogin
import SCMLocation
import SCMScoopInfo
import SCMPayment

final class DIContainer {
    static let shared: DIContainer = DIContainer()
    
    private init() {
        self.loginManager = LoginManager()
        self.signUpManager = SignUpManager()
        self.loginTokenManager = LoginTokenManager()
        self.deviceTokenManager = DeviceTokenManager()
        
        self.locationManager = LocationManager()
        
        let foodCategoryRepo = FoodCategoryRepository()
        self.foodCategoryRepository = AnyFoodCategoryDisplayable(foodCategoryRepo)
        let storeDetailRepo = StoreDetailRepository()
        self.storeDetailRepository = AnyStoreDetailDisplayable(storeDetailRepo)
        
        self.imageHelper = ImageHelper.shared
        
        self.communityPostRepository = CommunityPostRepository()
        self.createPostRepository = CreatePostRepository()
        
        self.paymentRepository = PaymentRepository()
        
        self.chatDBRepository = ChatDBRepository.shared
        self.chatListRepository = ChatListRepository(
            chatDBRepo: self.chatDBRepository,
            loginTokenManager: self.loginTokenManager
        )
        self.chatRoomRepository = ChatRoomRepository(
            chatDBRepo: self.chatDBRepository,
            loginTokenManager: self.loginTokenManager
        )
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
    private(set) var storeDetailRepository: AnyStoreDetailDisplayable
    
    /// SCMImageRequest
    private(set) var imageHelper: ImageHelper
    
    /// SCMCommunity
    private(set) var communityPostRepository: CommunityPostDisplayable
    private(set) var createPostRepository: CreatePostDisplayable
    
    /// SCMPayment
    private(set) var paymentRepository: PaymentDisplayable
    
    /// SCMChat
    private(set) var chatListRepository: ChatListDisplayable
    private(set) var chatRoomRepository: ChatRoomDisplayable
    
    /// Realm
    private(set) var chatDBRepository: SCMDataSource
}
