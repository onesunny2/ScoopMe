//
//  Participant.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/11/25.
//

import Foundation
import RealmSwift

final class Participant: Object {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    @Persisted var isActive: Bool
    
    convenience init(
        userID: String,
        nickname: String,
        profileImage: String? = nil,
        isActive: Bool
    ) {
        self.init()
        self.userID = userID
        self.nickname = nickname
        self.profileImage = profileImage
        self.isActive = isActive
    }
}
