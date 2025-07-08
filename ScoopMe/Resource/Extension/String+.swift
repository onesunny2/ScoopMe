//
//  String+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 7/9/25.
//

import Foundation

extension String {
    func isoStringToKoreanAMPM() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let koreanFormatter = DateFormatter()
        koreanFormatter.dateFormat = "a h:mm"
        koreanFormatter.locale = Locale(identifier: "ko_KR")
        
        return koreanFormatter.string(from: date)
    }
}
