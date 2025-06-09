//
//  Date+.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/8/25.
//

import Foundation

public extension Date {
    /// ISO8601 문자열을 Date로 변환
    static func from(iso8601String: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: iso8601String)
    }
    
    /// 현재 시간으로부터 상대적인 시간을 한국어로 반환
    func timeAgoFromNow() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)
        
        // 음수인 경우 (미래 시간)
        if timeInterval < 0 {
            return "미래"
        }
        
        let seconds = Int(timeInterval)
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        let months = days / 30
        let years = days / 365
        
        switch timeInterval {
        case 0..<60:
            return "방금 전"
        case 60..<3600: // 1분 ~ 1시간
            return "\(minutes)분 전"
        case 3600..<86400: // 1시간 ~ 1일
            let remainingMinutes = (seconds % 3600) / 60
            if remainingMinutes == 0 {
                return "\(hours)시간 전"
            } else {
                return "\(hours)시간 \(remainingMinutes)분 전"
            }
        case 86400..<604800: // 1일 ~ 1주
            return "\(days)일 전"
        case 604800..<2629746: // 1주 ~ 1개월 (약 30.44일)
            return "\(weeks)주 전"
        case 2629746..<31556952: // 1개월 ~ 1년
            return "\(months)개월 전"
        default: // 1년 이상
            return "\(years)년 전"
        }
    }
}
