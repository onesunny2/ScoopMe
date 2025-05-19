//
//  GeoLocationError.swift
//  SCMLocation
//
//  Created by Lee Wonsun on 5/19/25.
//

import Foundation

enum GeoLocationError: Error {
    case noAddressFound
    case geoCodingFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .noAddressFound:
            return "주소 정보를 찾을 수 없습니다."
        case .geoCodingFailed(let error):
            return "주소 변환 중 오류가 발생했습니다: \(error.localizedDescription)"
        }
    }
}
