//
//  Log.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/12/25.
//

import Foundation
import os.log

struct Log {
    /*
     # level
     - debug: 디버깅 로그
     - info: 문제 해결 정보
     - network: 네트워크 정보
     - error: 오류
     - custom: 커스텀 디버깅 로그
     */
    enum Level {
        case debug
        case info
        case network
        case error
        
        fileprivate var category: String {
            switch self {
            case .debug:
                return "🟡 DEBUG"
            case .info:
                return "🟠 INFO"
            case .network:
                return "🔵 NETWORK"
            case .error:
                return "🔴 ERROR"
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug: return OSLog.debug
            case .info: return OSLog.info
            case .network: return OSLog.network
            case .error: return OSLog.error
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .network: return .default
            case .error: return .error
            }
        }
    }
    
    static private func log(_ message: Any, _ arguments: [Any], level: Level, file: String = #file, line: Int = #line) {
        
        let filename = URL(fileURLWithPath: file).lastPathComponent
        let location = "\(filename):\(line)"
        let extraMessage: String = arguments.map({ String(describing: $0) }).joined(separator: " ")
        
        #if DEBUG
        // DEBUG 빌드에서는 모든 로그를 print로 출력 (Xcode 콘솔)
        let logMessage = (level.osLogType == .error || level.osLogType == .debug) ?
        "[\(location)] \(message) \(extraMessage)" :
        "\(message) \(extraMessage)"
        print("[\(Date())] \(level.category) \(logMessage)")
        #endif
        
        // RELEASE 빌드에서는 Error만 OS Log로 출력 (Console.app)
        if level.osLogType == .error {
            let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
            let logMessage = "[\(location)] \(message) \(extraMessage)"
            logger.error("\(logMessage, privacy: .public)")
        }
    }
}
extension Log {
    /**
     # debug
     - Note : 개발 중 코드 디버깅 시 사용할 수 있는 유용한 정보
     */
    static func debug(
        _ message: Any,
        _ arguments: Any...,
        file: String = #file,
        line: Int = #line
    ) {
        log(message, arguments, level: .debug, file: file, line: line)
    }
    
    /**
     # info
     - Note : 문제 해결시 활용할 수 있는, 도움이 되지만 필수적이지 않은 정보
     */
    static func info(
        _ message: Any,
        _ arguments: Any...,
        file: String = #file,
        line: Int = #line
    ) {
        log(message, arguments, level: .info, file: file, line: line)
    }
    
    /**
     # network
     - Note : 네트워크 문제 해결에 필수적인 정보
     */
    static func network(
        _ message: Any,
        _ arguments: Any...,
        file: String = #file,
        line: Int = #line
    ) {
        log(message, arguments, level: .network, file: file, line: line)
    }
    
    /**
     # error
     - Note : 코드 실행 중 나타난 에러
     */
    static func error(
        _ message: Any,
        _ arguments: Any...,
        file: String = #file,
        line: Int = #line
    ) {
        log(message, arguments, level: .error, file: file, line: line)
    }
}
