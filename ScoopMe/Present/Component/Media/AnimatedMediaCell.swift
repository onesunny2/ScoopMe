//
//  AnimatedMediaCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/29/25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct AnimatedMediaCell: View {
    
    let url: String
    
    var body: some View {
        AnimatedImage(url: URL(string: url))
            .onFailure { _ in
                RoundedRectangle(cornerRadius: 5)
                    .fill(.scmGray30)
            }
            .indicator(.progress)
            .transition(.fade(duration: 0.3))
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

//#Preview {
//    AnimatedMediaCell()
//}


final class SDWebImageCacheManager {
    static func configure() {
        // 메모리 캐시 설정 (100MB)
        SDImageCache.shared.config.maxMemoryCost = 100 * 1024 * 1024
        
        // 디스크 캐시 설정 (500MB)
        SDImageCache.shared.config.maxDiskSize = 500 * 1024 * 1024
        
        // 캐시 유효기간 (7일)
        SDImageCache.shared.config.maxDiskAge = 7 * 24 * 60 * 60
        
        // GIF/WEBP 우선 처리
        SDWebImageManager.shared.optionsProcessor = SDWebImageOptionsProcessor { url, options, context in
            var newOptions = options
            newOptions.insert(.refreshCached)
            return SDWebImageOptionsResult(options: newOptions, context: context)
        }
    }
}
