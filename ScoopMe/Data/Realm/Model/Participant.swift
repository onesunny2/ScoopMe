//
//  Participant.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/11/25.
//

import Foundation
import RealmSwift

/*
 < 참여자 모델에 필요한 내용 >
 - 유저아이디
 - 닉네임
 - 프로필이미지
 - 입장한 시간 (최신 메시지 받아오기 위함)
 - 나간 시간
 - 활성화 여부 (메시지 안보내 지는거 막으려고)
 */

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
