//
//  OSLog+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: LogCategory.network.string)
    static let debug = OSLog(subsystem: subsystem, category: LogCategory.debug.string)
    static let info = OSLog(subsystem: subsystem, category: LogCategory.info.string)
    static let error = OSLog(subsystem: subsystem, category: LogCategory.error.string)
    
    enum LogCategory: String {
        case network = "Network"
        case debug = "Debug"
        case info = "Info"
        case error = "Error"
        
        var string: String {
            return self.rawValue
        }
    }
}
