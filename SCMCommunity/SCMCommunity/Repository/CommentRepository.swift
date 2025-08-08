//
//  CommentRepository.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 8/7/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

public final class CommentRepository: CommentDisplayable {
    
    public let loginTokenManager: LoginTokenManager
    public let network: SCMNetworkImpl
    
    private var accessToken: String {
        return loginTokenManager.fetchToken(.accessToken)
    }
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func postComment(
        postID: String,
        content: PostComment
    ) async throws -> CommentResponseDTO {
        
        let value = CommentURL.postComment(access: accessToken, postID: postID, comment: content)
        let result = try await callRequest(value, type: CommentResponseDTO.self)
        
        Log.debug("✅ 댓글 작성 성공: \(result)")
        
        return result.response
    }
    
    public func editComment(comment: CommentInfo) async throws -> CommentResponseDTO {
        
        let value = CommentURL.editComment(access: accessToken, comment: comment)
        let result = try await callRequest(value, type: CommentResponseDTO.self)
        
        Log.debug("✅ 댓글 수정 성공: \(result)")
        
        return result.response
    }
    
    public func deleteComment(postID: String, commentID: String) async throws {
        
    }
}
