//
//  MultipartFormData.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 6/3/25.
//

import Foundation

public struct MultipartFormData {
    public struct FormField {
        let name: String
        let value: String
        
        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
    
    public struct FileData {
        let name: String
        let data: Data
        let filename: String
        let mimeType: String
        
        public init(name: String, data: Data, filename: String, mimeType: String = "image/jpeg") {
            self.name = name
            self.data = data
            self.filename = filename
            self.mimeType = mimeType
        }
    }
    
    let boundary: String
    let fields: [FormField]
    let files: [FileData]
    
    public init(fields: [FormField] = [], files: [FileData] = []) {
        self.boundary = "Boundary-\(UUID().uuidString)"
        self.fields = fields
        self.files = files
    }
    
    var contentType: String {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    var httpBody: Data {
        var body = Data()
        
        // 일반 필드들 추가
        for field in fields {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(field.name)\"\r\n\r\n")
            body.append("\(field.value)\r\n")
        }
        
        // 파일 데이터들 추가
        for file in files {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.filename)\"\r\n")
            body.append("Content-Type: \(file.mimeType)\r\n\r\n")
            body.append(file.data)
            body.append("\r\n")
        }
        
        // 종료 boundary
        body.append("--\(boundary)--\r\n")
        
        return body
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
