//
//  Secret.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

enum Secret {
    static let apiKey: String = {
        guard let urlString = Bundle.main.infoDictionary?["APIKey"] as? String else {
            fatalError("APIKey ERROR")
        }
        return urlString
    }()
    
    static let baseURL: String = {
        guard let urlString = Bundle.main.infoDictionary?["BaseURL"] as? String else {
            fatalError("BaseURL ERROR")
        }
        return urlString
    }()
    
    static let kakaoKey: String = {
        guard let urlString = Bundle.main.infoDictionary?["KAKAO_Native_Key"] as? String else {
            fatalError("KAKAO_Native_Key ERROR")
        }
        return urlString
    }()
}
