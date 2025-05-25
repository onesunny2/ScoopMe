//
//  SavedLocation.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 5/19/25.
//

import Foundation

public struct SavedLocation: Codable, Equatable {
    public let latitude: Double
    public let longitude: Double
    public let locationNickname: String
    public let longAddress: String
    public let shortAddress: String
    public let adressDetail: String
    
    public init(
        latitude: Double,
        longitude: Double,
        locationNickname: String,
        longAddress: String,
        shortAddress: String,
        adressDetail: String
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.locationNickname = locationNickname
        self.longAddress = longAddress
        self.shortAddress = shortAddress
        self.adressDetail = adressDetail
    }
}
