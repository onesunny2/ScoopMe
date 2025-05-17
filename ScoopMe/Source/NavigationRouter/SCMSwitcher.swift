//
//  SCMSwitcher.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import Foundation
import SCMLogin

final class SCMSwitcher: ObservableObject {
    static let shared = SCMSwitcher()
    private init() { }
    
    @Published var currentFlow: MainFlow = .splash(LoginTokenManager())  // 초기화면 splash
    
    func switchTo(_ flow: MainFlow) {
        currentFlow = flow
    }
}
