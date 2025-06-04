//
//  CreatePostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import Combine
import SCMNetwork

public protocol CreatePostDisplayable: AnyObject, ObservableObject {
    
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    
    func postFiles(_ files: [FileData]) async throws -> PostFilesEntity
    func postContents(_ content: PostContent) async throws
    func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async
}
