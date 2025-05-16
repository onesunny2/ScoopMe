//
//  Logger+Extension.swift
//  SCMLogger
//
//  Created by Lee Wonsun on 5/16/25.
//

import Foundation
import os

public extension Logger {
    static let subsystem = Bundle.main.bundleIdentifier ?? "com.Tynee.ScoopMe"
    
    static let network = Logger(subsystem: subsystem, category: "NETWORK")
    static let debug = Logger(subsystem: subsystem, category: "DEBUG")
    static let info = Logger(subsystem: subsystem, category: "INFO")
    static let error = Logger(subsystem: subsystem, category: "ERROR")
}
