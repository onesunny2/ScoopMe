//
//  Date+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/16/25.
//

import Foundation

extension Date {
    func toKoreanTimeString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: self)
    }
}
