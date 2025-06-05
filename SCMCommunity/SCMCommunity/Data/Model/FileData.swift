//
//  FileData.swift
//  SCMCommunity
//
//  Created by Lee Wonsun on 6/5/25.
//

import UIKit

public enum FileData {
    case image(UIImage, fileName: String, mimeType: String)
    case video(URL, fileName: String, mimeType: String)
}
