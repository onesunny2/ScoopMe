//
//  CreatePostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import Combine

public protocol CreatePostDisplayable: AnyObject, ObservableObject {
    
    var showAlert: Bool { get set }
    var alertTitle: String { get set }
    var alertMessage: String { get set }
    
    func postFiles(_ files: [String]) async throws -> PostFilesEntity
    func checkTokenValidation(_ error: Error, complete: @escaping () async throws -> ()) async
}
