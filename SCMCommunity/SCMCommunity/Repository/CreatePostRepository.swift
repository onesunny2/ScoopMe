//
//  CreatePostRepository.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation
import SCMLogger
import SCMLogin
import SCMNetwork

public final class CreatePostRepository: CreatePostDisplayable {
    
    public let loginTokenManager: LoginTokenManager
    public let network: SCMNetworkImpl
    
    public init() {
        self.loginTokenManager = LoginTokenManager()
        self.network = SCMNetworkImpl()
    }
    
    public func postFiles(_ files: [FileData]) async throws -> PostFilesEntity {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = CommunityURL.fileUpload(access: accessToken, files: files)
        let result = try await callMultipartRequest(value, type: FileResponseDTO.self)
        
        let urls = result.response.files
        
        Log.debug("🔗 파일 업로드 성공: \(urls)")
        
        return PostFilesEntity(files: urls)
    }
    
    public func postContents(_ content: PostContent) async throws {
        
        let accessToken = loginTokenManager.fetchToken(.accessToken)
        let value = CommunityURL.postUpload(access: accessToken, value: content)
        let result = try await callRequest(value, type: PostResponseDTO.self)
        
        Log.debug("🔗 포스트 업로드 성공: \(result.response)")
    }
}
