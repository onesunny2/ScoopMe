//
//  KeychainError.swift
//  SCMLogin
//
//  Created by Lee Wonsun on 5/15/25.
//

import Foundation

public enum KeychainError: Error {
    case noSavedData
    case unexpectedSavedData
    case unhandledError(status: OSStatus)
}
