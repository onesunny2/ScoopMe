//
//  Navigation.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/17/25.
//

import Foundation

final class SCMRouter<P: Hashable>: ObservableObject {
    private init() { }
    
    @Published var path = Array<P>()
    
    func send(_ action: Action) {
        handleAction(action)
    }
    
    private func handleAction(_ action: SCMRouter<P>.Action) {
        switch action {
        case .push(let view):
            path.append(view)
        case .pop:
            path.removeLast()
        case .pops(let count):
            let removeCount = min(count, path.count)
            path.removeLast(count)
        case .popAll:
            path.removeAll()
        }
    }
}

extension SCMRouter where SCMRouter == SCMRouter<LoginPath> {
    static let shared = SCMRouter()
}

extension SCMRouter where SCMRouter == SCMRouter<MainFlow> {
    static let shared = SCMRouter()
}

extension SCMRouter where SCMRouter == SCMRouter<TabFlow> {
    static let shared = SCMRouter()
}

extension SCMRouter {
    enum Action {
        case push(P)
        case pop
        case pops(Int)
        case popAll
    }
}
