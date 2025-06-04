//
//  MultipartFormData.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 6/3/25.
//

import UIKit

public struct MultipartFormData {
    private let boundary: String
    private var data: Data
    
    public var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    public var httpBody: Data {
        return data
    }
    
    public init() {
        self.boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        self.data = Data()
    }
    
    // 텍스트 파라미터 추가
    public mutating func append(_ value: String, withName name: String) {
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
    }
    
    // 이미지 데이터 추가
    public mutating func append(_ image: UIImage, withName name: String, fileName: String = "image.jpg", mimeType: String = "image/jpeg") {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n".data(using: .utf8)!)
    }
    
    // 동영상 데이터 추가
    public mutating func append(_ videoURL: URL, withName name: String, fileName: String = "video.mp4", mimeType: String = "video/mp4") throws {
        let videoData = try Data(contentsOf: videoURL)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        data.append(videoData)
        data.append("\r\n".data(using: .utf8)!)
    }
    
    // Boundary 종료
    public mutating func finalize() {
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }
}
