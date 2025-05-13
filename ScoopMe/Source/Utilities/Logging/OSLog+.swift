//
//  OSLog+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? "com.Tynee.ScoopMe"
    
    static let network = OSLog(subsystem: subsystem, category: "NETWORK")
    static let debug = OSLog(subsystem: subsystem, category: "DEBUG")
    static let info = OSLog(subsystem: subsystem, category: "INFO")
    static let error = OSLog(subsystem: subsystem, category: "ERROR")
}
