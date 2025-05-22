//
//  Array+.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import Foundation

extension Array where Element == String {
    
    subscript(at index: Int) -> String {
        return indices.contains(index) ? self[index] : ""
    }
}
