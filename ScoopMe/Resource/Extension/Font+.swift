//
//  Font+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/10/25.
//

import SwiftUI

extension Font {
    
    /// Jalnan
    static let JNLargeTitle1: Font = .custom(Name.jalnanGothic.text, size: 40)
    static let JNLargeTitle2: Font = .custom(Name.jalnanGothic.text, size: 30)
    
    static let JNTitle1: Font = .custom(Name.jalnanGothic.text, size: 24)
    
    static let JNBody1: Font = .custom(Name.jalnanGothic.text, size: 20)
    
    static let JNCaption1: Font = .custom(Name.jalnanGothic.text, size: 14)
    
    /// Pretendard
    static let PTTitle1: Font = .custom(Name.pretendardB.text, size: 20)
    static let PTTitie2: Font = .custom(Name.pretendardM.text, size: 20)
    static let PTTitle3: Font = .custom(Name.pretendardB.text, size: 16)
    
    static let PTBody1: Font = .custom(Name.pretendardM.text, size: 16)
    static let PTBody2: Font = .custom(Name.pretendardM.text, size: 14)
    static let PTBody3: Font = .custom(Name.pretendardM.text, size: 13)
    
    static let PTCaption1: Font = .custom(Name.pretendardR.text, size: 12)
    static let PTCaption2: Font = .custom(Name.pretendardR.text, size: 10)
    static let PTCaption3: Font = .custom(Name.pretendardR.text, size: 8)
    
    enum Name: String {
        case pretendardB = "Pretendard-Bold"
        case pretendardM = "Pretendard-Medium"
        case pretendardR = "Pretendard-Regular"
        case pretendartSM = "Pretendard-SemiBold"
        case jalnanGothic = "JalnanGothic"
        
        var text: String {
            return self.rawValue
        }
    }
}
