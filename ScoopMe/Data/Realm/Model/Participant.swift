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
    @Persisted var enteredTime: String?
    @Persisted var exitedTime: String?
    @Persisted var isActive: Bool
    
    convenience init(
        userID: String,
        nickname: String,
        profileImage: String? = nil,
        enteredTime: String? = nil,
        exitedTime: String? = nil,
        isActive: Bool
    ) {
        self.init()
        self.userID = userID
        self.nickname = nickname
        self.profileImage = profileImage
        self.enteredTime = enteredTime
        self.exitedTime = exitedTime
        self.isActive = isActive
    }
}
