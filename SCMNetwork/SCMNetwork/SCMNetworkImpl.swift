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
    
    public func fetchData<T: Decodable>(_ request: HTTPRequest, _ type: T.Type) async throws -> HTTPResponse<T> {
        
        do {
            let urlRequest = try request.urlRequest()
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else { throw SCMError.invalidResponse }
            
            let headers = httpResponse.allHeaderFields as? [String: String]
            
            guard request.successCodes.contains(httpResponse.statusCode) else {
                let errorMessage = getErrorMessage(from: data)
                throw SCMError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)
            }
            
            let decodingResponse = try decoder.decode(T.self, from: data)
            
            return HTTPResponse(
                statusCode: httpResponse.statusCode,
                response: decodingResponse,
                headers: headers
            )
            
        } catch {
            switch error {
            case let scmError as SCMError: throw scmError
            case let decodingError as DecodingError: throw SCMError.decodingFailed(decodingError)
            case let urlError as URLError: throw SCMError.requestFailed(urlError)
            default: throw SCMError.requestFailed(error)
            }
        }
    }
    
    private func getErrorMessage(from data: Data) -> String {
        
        guard let jsonString = String(data: data, encoding: .utf8) else { return "Unknown error" }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let message = json["message"] as? String {
                return message
            }
        } catch {
            print("Json 파싱 오류: \(error)")
        }
        
        return jsonString.isEmpty ? "Unknown error" : jsonString
    }
}
