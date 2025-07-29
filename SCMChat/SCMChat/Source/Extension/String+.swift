//
//  String+.swift
//  SCMChat
//
//  Created by Lee Wonsun on 7/2/25.
//

import Foundation

public extension String {
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
