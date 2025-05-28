//
//  StoreDetailResponseDTO.swift
//  SCMScoopInfo
//
//  Created by Lee Wonsun on 5/28/25.
//

import Foundation

struct StoreDetailResponseDTO: Codable {
    let storeID: String
    let category: String?
    let name: String?
    let description: String?
    let hashTags: [String]
    let open: String?
    let close: String?
    let address: String?
    let estimatedPickupTime: Int
    let parkingGuide: String?
    let storeImageUrls: [String]
    let isPicchelin: Bool
    let isPick: Bool
    let pickCount: Int
    let totalReviewCount: Int
    let totalOrderCount: Int
    let totalRating: Double
    let creator: UserInfoResponseDTO
    let geolocation: Geolocation
    let menuList: [MenuResponseDTO]
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case storeID = "store_id"
        case category, name, description
        case hashTags
        case open, close, address
        case estimatedPickupTime = "estimated_pickup_time"
        case parkingGuide = "parking_guide"
        case storeImageUrls = "store_image_urls"
        case isPicchelin = "is_picchelin"
        case isPick = "is_pick"
        case pickCount = "pick_count"
        case totalReviewCount = "total_review_count"
        case totalOrderCount = "total_order_count"
        case totalRating = "total_rating"
        case creator
        case geolocation
        case menuList = "menu_list"
        case createdAt, updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.storeID = try container.decode(String.self, forKey: .storeID)
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.hashTags = try container.decode([String].self, forKey: .hashTags)
        self.open = try container.decodeIfPresent(String.self, forKey: .open) ?? ""
        self.close = try container.decodeIfPresent(String.self, forKey: .close) ?? ""
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.estimatedPickupTime = try container.decode(Int.self, forKey: .estimatedPickupTime)
        self.parkingGuide = try container.decodeIfPresent(String.self, forKey: .parkingGuide) ?? ""
        self.storeImageUrls = try container.decode([String].self, forKey: .storeImageUrls)
        self.isPicchelin = try container.decode(Bool.self, forKey: .isPicchelin)
        self.isPick = try container.decode(Bool.self, forKey: .isPick)
        self.pickCount = try container.decode(Int.self, forKey: .pickCount)
        self.totalReviewCount = try container.decode(Int.self, forKey: .totalReviewCount)
        self.totalOrderCount = try container.decode(Int.self, forKey: .totalOrderCount)
        self.totalRating = try container.decode(Double.self, forKey: .totalRating)
        self.creator = try container.decode(UserInfoResponseDTO.self, forKey: .creator)
        self.geolocation = try container.decode(Geolocation.self, forKey: .geolocation)
        self.menuList = try container.decode([MenuResponseDTO].self, forKey: .menuList)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
}

struct UserInfoResponseDTO: Codable {
    let userID: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}

struct MenuResponseDTO: Codable {
    let menuID: String
    let storeID: String
    let category: String?
    let name: String
    let description: String?
    let originInformation: String?
    let price: Int
    let isSoldOut: Bool
    let tags: [String]
    let menuImageUrl: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case menuID = "menu_id"
        case storeID = "store_id"
        case category, name, description
        case originInformation = "origin_information"
        case price
        case isSoldOut = "is_sold_out"
        case tags
        case menuImageUrl = "menu_image_url"
        case createdAt, updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.menuID = try container.decode(String.self, forKey: .menuID)
        self.storeID = try container.decode(String.self, forKey: .storeID)
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.originInformation = try container.decodeIfPresent(String.self, forKey: .originInformation) ?? ""
        self.price = try container.decode(Int.self, forKey: .price)
        self.isSoldOut = try container.decode(Bool.self, forKey: .isSoldOut)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.menuImageUrl = try container.decodeIfPresent(String.self, forKey: .menuImageUrl) ?? ""
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
}
