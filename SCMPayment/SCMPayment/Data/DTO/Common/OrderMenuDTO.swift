//
//  OrderMenuDTO.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/13/25.
//

import Foundation

struct OrderMenuDTO: Codable {
    let menu: MenuResponseDTOOrder
    let quantity: Double
}
