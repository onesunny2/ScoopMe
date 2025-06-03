//
//  PostMediaItem.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 6/3/25.
//

import SwiftUI

struct PostMediaItem: Identifiable, Equatable {
    let id = UUID()
    let itemIdentifier: String
    let image: Image?
    let videoURL: URL?
    
    var isImage: Bool { image != nil }
    var isVideo: Bool { videoURL != nil }
}
