//
//  SCMNetworkImpl.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation

public final class SCMNetworkImpl: NetworkManager {
    
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    public init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        self.session = URLSession(configuration: config)
    }
    
    public func fetchData<T: Decodable>(_ request: HTTPRequest, _ type: T.Type) async throws -> T {
        
        do {
            let request = try request.urlRequest()
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw SCMError.invalidResponse }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                var errorMessage = ""
                
                // JSON 파싱 시도
                if let jsonString = String(data: data, encoding: .utf8) {
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            // message 필드가 있는 경우
                            if let message = json["message"] as? String {
                                errorMessage = message
                            }
                        }
                    } catch {
                        print("JSON 파싱 오류: \(error)")
                        throw SCMError.serverError(statusCode: httpResponse.statusCode, message: "\(error.localizedDescription)")
                    }
                }
                
                throw SCMError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)
            }
            
            return try decoder.decode(T.self, from: data)
            
        } catch {
            guard let decodingError = error as? SCMError else { throw error }
            throw SCMError.decodingFailed(decodingError)
        }
    }
}
