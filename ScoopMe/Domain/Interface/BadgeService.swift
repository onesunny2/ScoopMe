//
//  BadgeService.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/31/25.
//

import Foundation

protocol BadgeService: AnyObject {
    func addBadgeCount(roomID: String)
    func clearBadgeCount(roomID: String) async
}
