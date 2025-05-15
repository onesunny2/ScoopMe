//
//  UserServiceProtocol.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/14/25.
//

import Foundation
import Combine
internal import SCMNetwork

protocol UserServiceProtocol: NetworkServiceProtocol, ObservableObject {
    
    var alertTitle: String { get set }
    var alertMessage: String { get set }
}

extension UserServiceProtocol {
    
    @MainActor
    func handleError(_ error: Error, _ alertMessage: inout String) {
        
        guard let scmError = error as? SCMError else { return }
        
        switch scmError {
        case .serverError(_, let message):
            alertMessage = message
        default:
            alertMessage = scmError.localizedDescription
        }
    }
}
