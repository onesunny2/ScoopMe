//
//  SCMError.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public enum SCMError: Error {
    case invalidURL
    case invalidResponse
    case invalidParameter
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, message: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "유효하지 않은 URL입니다."
        case .invalidResponse: return "유효하지 않은 응답입니다."
        case .invalidParameter: return "유효하지 않은 파라미터입니다."
        case .requestFailed(let error): return "요청에 실패했습니다: \(error.localizedDescription)"
        case .decodingFailed(let error): return "응답 디코딩에 실패했습니다: \(error.localizedDescription)"
        case let .serverError(statusCode, message): return "서버 에러 (상태 코드: \(statusCode))\n\(message)"
        }
    }
}
