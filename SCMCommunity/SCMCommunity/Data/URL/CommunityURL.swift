//
//  CommunityURL.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/3/25.
//

import UIKit
import SCMNetwork

public enum CommunityURL {
    case fileUpload(access: String, files: [FileData])
    case postUpload(access: String, value: PostContent)
    case getCommunityPost(access: String, value: GeolocationPost)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .getCommunityPost:
            return .get
        default:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fileUpload: "/v1/posts/files"
        case .postUpload: "/v1/posts"
        case .getCommunityPost: "/v1/posts/geolocation"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        case let .getCommunityPost(_, value):
            return [
                "category": value.category,
                "latitude": value.latitude,
                "longitude": value.longitude,
                "maxDistance": value.maxDistance,
                "limit": "\(value.limit)",
                "next": value.next,
                "order_by": value.orderBy.query
            ]
        default: return nil
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        case let .postUpload(_, value):
            return [
                "category": value.categoty,
                "title": value.title,
                "content": value.content,
                "store_id": value.storeID,
                "latitude": value.latitude,
                "longitude": value.longitude,
                "files": value.files
            ]
        default: return nil
        }
    }
    
    var multipartData: MultipartFormData? {
         switch self {
         case let .fileUpload(_, files):
             var multipartData = MultipartFormData()
             
             // 파일 추가
             for file in files {
                 switch file {
                 case .image(let image, let fileName, let mimeType):
                     multipartData.append(image, withName: "files", fileName: fileName, mimeType: mimeType)
                 case .video(let videoURL, let fileName, let mimeType):
                     try? multipartData.append(videoURL, withName: "files", fileName: fileName, mimeType: mimeType)
                 }
             }
             multipartData.finalize()
             return multipartData
         default:
             return nil
         }
     }
    
    var headers: [String: String] {
        switch self {
        case let .fileUpload(access, _):
            return [
                "Content-Type": "multipart/form-data",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .postUpload(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .getCommunityPost(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}
