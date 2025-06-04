//
//  UTTypeHelper.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/4/25.
//

import UIKit
import UniformTypeIdentifiers

enum UTTypeHelper {
    static func getUTTypeFromImageData(_ imageData: Data) -> UTType? {
        // 데이터의 첫 바이트들을 확인하여 이미지 형식 추정
        if imageData.count < 12 { return nil }
        
        let bytes = imageData.prefix(12)
        
        // JPEG 확인
        if bytes.starts(with: [0xFF, 0xD8, 0xFF]) {
            return UTType.jpeg
        }
        
        // PNG 확인
        if bytes.starts(with: [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]) {
            return UTType.png
        }
        
        // GIF 확인
        if bytes.starts(with: [0x47, 0x49, 0x46]) {
            return UTType.gif
        }
        
        // WebP 확인 (RIFF...WEBP)
        if bytes.starts(with: [0x52, 0x49, 0x46, 0x46]) &&
           bytes.suffix(from: 8).starts(with: [0x57, 0x45, 0x42, 0x50]) {
            return UTType.webP
        }
        
        return nil
    }
}
