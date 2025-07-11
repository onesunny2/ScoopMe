//
//  MessageRecord.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/11/25.
//

import Foundation
import RealmSwift

/*
 < 메시지 모델에 필요한 내용 >
 - 채팅아이디
 - 보낸사람 (isMine으로 처리)
 - 전송상태
 - 읽음상태 (별도 모델)
 - 메시지 타입
 - 미디어 종류 (별도 모델)
 - 보낸 날짜
 */

final class MessageRecord: Object {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted var isMine: Bool
    @Persisted var sendStatus: String
    @Persisted var messageType: String
    @Persisted var createdAt: String
    @Persisted var readStatus: List<ReadStatus>
    
    convenience init(
        chatID: String,
        isMine: Bool,
        sendStatus: String,
        messageType: String,
        createdAt: String,
        readStatus: List<ReadStatus>
    ) {
        self.init()
        self.chatID = chatID
        self.isMine = isMine
        self.sendStatus = sendStatus
        self.messageType = messageType
        self.createdAt = createdAt
        self.readStatus = readStatus
    }
}
