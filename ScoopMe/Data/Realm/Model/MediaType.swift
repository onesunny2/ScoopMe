//
//  MediaType.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

/*
 < 미디어 종류 >
 - 파일이름
 - 용량
 - mimeType
 */

final class MediaType: EmbeddedObject {
    @Persisted(primaryKey: true) var fileName: String
    @Persisted var fileSize: Double
    @Persisted var mimeType: String
}
