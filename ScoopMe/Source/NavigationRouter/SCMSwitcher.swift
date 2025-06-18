//
//  SCMSwitcher.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import SwiftUI
import SCMLogin

final class SCMSwitcher<FlowType: Hashable>: ObservableObject {
    
    @Published var currentFlow: FlowType
    
    init(initialFlow: FlowType) {
        self.currentFlow = initialFlow
    }
    
    @MainActor
    func switchTo(_ flow: FlowType) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFlow = flow
        }
    }
}

extension SCMSwitcher where FlowType == MainFlow {
    static let shared = SCMSwitcher(initialFlow: .splash(LoginTokenManager()))
}

extension SCMSwitcher where FlowType == TabFlow {
    static let shared = SCMSwitcher(initialFlow: .home)
}
