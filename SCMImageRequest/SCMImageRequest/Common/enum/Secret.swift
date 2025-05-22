//
//  Secret.swift
//  SCMImageRequest
//
//  Created by Lee Wonsun on 5/21/25.
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
}
