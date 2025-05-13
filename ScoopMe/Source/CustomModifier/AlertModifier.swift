//
//  AlertModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/13/25.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    
    @Binding var showAlert: Bool
    let title: String
    let message: String
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $showAlert) {
                Button("확인", role: .none) { }
            } message: {
                Text(message)
            }
    }
}

struct AlertMultiModifier: ViewModifier {
    
    @Binding var showAlert: Bool
    let title: String
    let message: String
    let okayAction: () -> ()
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $showAlert) {
                Button("취소", role: .none) { }
                Button("확인", role: .cancel) { okayAction() }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func showAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String
    ) -> some View {
        modifier(AlertModifier(showAlert: isPresented, title: title, message: message))
    }
    
    func showAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        action: @escaping () -> ()
    ) -> some View {
        modifier(AlertMultiModifier(showAlert: isPresented, title: title, message: message, okayAction: action))
    }
}
