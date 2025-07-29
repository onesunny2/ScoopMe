//
//  MediaType.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/15/25.
//

import Foundation
import RealmSwift

final class MediaType: EmbeddedObject {
    @Persisted var fileName: String
    @Persisted var fileSize: Double
    @Persisted var mimeType: String
}
