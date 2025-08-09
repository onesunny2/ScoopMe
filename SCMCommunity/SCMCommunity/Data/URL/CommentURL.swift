//
//  CommentURL.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 8/7/25.
//

import Foundation
import SCMNetwork

public enum CommentURL {
    case postComment(access: String, postID: String, comment: PostComment)
    case editComment(access: String,comment: CommentInfo)
    case deleteComment(access: String, comment: CommentInfo)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .postComment:
            return .post
        case .deleteComment:
            return .delete
        case .editComment:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case let .postComment(_, postID, _):
            "/v1/posts/\(postID)/comments"
        case let .editComment(_, comment):
            "/v1/posts/\(comment.postID)/comments/\(comment.commentID)"
        case let .deleteComment(_, comment):
            "/v1/posts/\(comment.postID)/comments/\(comment.commentID)"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        default: return nil
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        case let .postComment(_, _, comment):
            return [
                "parent_comment_id": comment.parentID,
                "content": comment.content
            ]
        case let .editComment(_, comment):
            return [
                "content": comment.content
            ]
        default: return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .postComment(access, _, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .editComment(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .deleteComment(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}
