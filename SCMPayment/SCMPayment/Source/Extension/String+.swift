//
//  String+.swift
//  SCMPayment
//
//  Created by Lee Wonsun on 6/13/25.
//

import Foundation

extension String {
    
    func toKoreanDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = isoFormatter.date(from: self) else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy년 M월 d일 a h시 m분"

        return formatter.string(from: date)
    }
    
    func toKoreanTime() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = isoFormatter.date(from: self) else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "a h:mm"

        return formatter.string(from: date)
    }
}
