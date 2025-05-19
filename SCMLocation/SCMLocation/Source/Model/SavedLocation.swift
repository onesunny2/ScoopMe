//
//  SavedLocation.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 5/19/25.
//

import Foundation

struct SavedLocation: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let longAddress: String
    let shortAddress: String
    let adressDetail: String
}
