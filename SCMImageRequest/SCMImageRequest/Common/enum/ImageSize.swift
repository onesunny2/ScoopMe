//
//  ImageSize.swift
//  SCMImageRequest
//
//  Created by Lee Wonsun on 8/4/25.
//

import Foundation

public enum ImageSize {
    case thumbnail
    case small
    case medium
    case large
    case original
    case custom(CGSize)
    
    var cgSize: CGSize? {
        switch self {
        case .thumbnail:
            return CGSize(width: 100, height: 100)
        case .small:
            return CGSize(width: 200, height: 200)
        case .medium:
            return CGSize(width: 300, height: 300)
        case .large:
            return CGSize(width: 500, height: 500)
        case .original:
            return nil
        case .custom(let size):
            return size
        }
    }
}
