//
//  ChatMessage.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/10/25.
//

import Foundation
import RealmSwift
import SCMLogger

/*
 < 채팅방 필요한 요소 >
 - 룸ID
 - 사용자 정보 -> participant로 ㄱㄱ
    ㄴ 유저아이디, 유저닉네임, 프로필이미지
 - 생성날짜
 - 최근 메시지 날짜, 최근 메시지 내용
 - 매시지 내역
 - 활성화 유무 -> 소프트삭제
 ㄴ 실제 삭제는 일정 기간(30일?)정도 두고, 혹은 사용자의 요청 시 삭제
 */

final class ChatRoom: Object {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var createdAt: String
    @Persisted var participant = List<Participant>()
    @Persisted var lastMessageAt: String
    @Persisted var lastMessageContent: String
    @Persisted var isActive: Bool
    @Persisted var messages = List<MessageRecord>()
    
    convenience init(
        roomID: String,
        createdAt: String,
        participant: List<Participant> = List<Participant>(),
        lastMessageAt: String,
        lastMessageContent: String,
        isActive: Bool,
        messages: List<MessageRecord> = List<MessageRecord>()
    ) {
        self.init()
        self.roomID = roomID
        self.createdAt = createdAt
        self.participant = participant
        self.lastMessageAt = lastMessageAt
        self.lastMessageContent = lastMessageContent
        self.isActive = isActive
        self.messages = messages
    }
}
