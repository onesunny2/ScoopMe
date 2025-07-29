//
//  ReadStatus.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

final class ReadStatus: EmbeddedObject {
    @Persisted var userID: String
    @Persisted var readAt: String?
}
