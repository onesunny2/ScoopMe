//
//  ScoopInfoURL.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/22/25.
//

import Foundation
internal import SCMNetwork

public enum ScoopInfoURL {
    case nearbyStoreFirst(access: String, category: String, longitude: Float, latitude: Float, limit: Int, orderBy: AroundFilterType)
    case nearbyStoreNext(access: String, category: String, longitude: Float, latitude: Float, next: String, limit: Int, orderBy: AroundFilterType)
    case popularKeyword(access: String)
    case realtimePopularStores(access: String, category: Category)
    case postStoreLike(access: String, storeID: String, status: Bool)
    
    var baseURL: String {
        return Secret.baseURL
    }
    
    var method: HTTPMethods {
        switch self {
        case .postStoreLike:
            return .post
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .nearbyStoreFirst, .nearbyStoreNext: "/v1/stores"
        case .popularKeyword: "/v1/stores/searches-popular"
        case .realtimePopularStores: "/v1/stores/popular-stores"
        case let .postStoreLike(_, storeID, _): "/v1/stores/\(storeID)/like"
        }
    }
    
    var parameters: [String: String?]? {
        switch self {
        case let .nearbyStoreFirst(_, category, longitude, latitude, limit, orderBy):
            return [
                "category": category,
                "longitude": "\(longitude)",
                "latitude": "\(latitude)",
                "limit": "\(limit)",
                "order_by": orderBy.query
            ]
        case let .nearbyStoreNext(_, category, longitude, latitude, next, limit, orderBy):
            return [
                "category": category,
                "longitude": "\(longitude)",
                "latitude": "\(latitude)",
                "limit": "\(limit)",
                "next": next,
                "order_by": orderBy.query
            ]
        case let .realtimePopularStores(_, category):
            return ["category" : category.text]
        default: return nil
        }
    }
    
    var jsonBody: [String: Any?]? {
        switch self {
        case let .postStoreLike(_, _, likeStatus):
            return ["like_status": likeStatus]
        default: return nil
        }
    }
    
    var headers: [String: String] {
        switch self {
        case let .nearbyStoreFirst(access, _, _, _, _, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .nearbyStoreNext(access, _, _, _, _, _, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .popularKeyword(access):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .realtimePopularStores(access, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        case let .postStoreLike(access, _, _):
            return [
                "Content-Type": "application/json",
                "SeSACKey": Secret.apiKey,
                "Authorization": access
            ]
        }
    }
}
