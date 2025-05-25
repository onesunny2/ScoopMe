//
//  Schemes.swift
//  SCMNetwork
//
//  Created by Lee Wonsun on 5/11/25.
//

import Foundation

public enum Schemes: String {
    case http
    case https
    case ws
    case wss
    
    public var string: String { return self.rawValue }
}
