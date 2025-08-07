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
    
    func toRelativeTime() -> String {
           // ISO8601 날짜 형식을 파싱하기 위한 DateFormatter
           let formatter = ISO8601DateFormatter()
           formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
           
           guard let date = formatter.date(from: self) else {
               return "시간 정보 없음"
           }
           
           let now = Date()
           let timeInterval = now.timeIntervalSince(date)
           
           // 미래 시간인 경우
           if timeInterval < 0 {
               return "방금 전"
           }
           
           let seconds = Int(timeInterval)
           let minutes = seconds / 60
           let hours = minutes / 60
           let days = hours / 24
           let weeks = days / 7
           
           switch timeInterval {
           case 0..<60:
               return "방금 전"
           case 60..<3600:
               return "\(minutes)분 전"
           case 3600..<86400:
               return "\(hours)시간 전"
           case 86400..<604800:
               return "\(days)일 전"
           default:
               return "\(weeks)주 전"
           }
       }
}
