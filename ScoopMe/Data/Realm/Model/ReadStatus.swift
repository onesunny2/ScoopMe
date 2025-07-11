//
//  ReadStatus.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

/*
 < 읽음상태 모델 >
 - 유저 아이디
 - 읽은 날짜
 */

final class ReadStatus: EmbeddedObject {
    @Persisted(primaryKey: true) var userID: String
    @Persisted var readAt: String?
}
