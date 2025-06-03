//
//  AnyCreatePostDisplayable.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import Combine

public final class AnyCreatePostDisplayable: CreatePostDisplayable, ObservableObject {
    private let _base: any CreatePostDisplayable
    
    @Published public var showAlert: Bool {
        didSet {
            _base.showAlert = showAlert
        }
    }
    
    @Published public var alertTitle: String {
        didSet {
            _base.alertTitle = alertTitle
        }
    }
    
    @Published public var alertMessage: String {
        didSet {
            _base.alertMessage = alertMessage
        }
    }
    
    public init(_ base: any CreatePostDisplayable) {
        self._base = base
        self.showAlert = base.showAlert
        self.alertTitle = base.alertTitle
        self.alertMessage = base.alertMessage
    }
    
    public func postFiles(_ files: [String]) async throws -> PostFilesEntity {
        try await _base.postFiles(files)
    }
    
    public func checkTokenValidation(_ error: any Error, complete: @escaping () async throws -> ()) async {
        await _base.checkTokenValidation(error, complete: complete)
    }
}
