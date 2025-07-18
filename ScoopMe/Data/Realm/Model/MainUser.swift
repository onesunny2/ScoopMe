//
//  MainUser.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/19/25.
//

import Foundation
import RealmSwift

final class MainUser: EmbeddedObject {
    @Persisted var userID: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(
        userID: String,
        nickname: String,
        profileImage: String? = nil
    ) {
        self.init()
        self.userID = userID
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
