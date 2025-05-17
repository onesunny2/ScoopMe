//
//  MainFlow.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/16/25.
//

import Foundation
import SCMLogin

enum MainFlow: Hashable {
    case splash
    case login(LoginManager)
    case main
}
