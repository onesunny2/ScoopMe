//
//  BadgeOverlayModifier.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/21/25.
//

import SwiftUI

struct BadgeOverlayModifier: ViewModifier {
    
    let likeStatus: Bool
    let picchelinStatus: Bool
    let likeOpacity: Double
    let padding: CGFloat
    
    var likeButtonAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .topLeading) {
                badges()
                    .padding([.leading, .top], padding)
            }
    }
    
    private func badges() -> some View {
        
        HStack(alignment: .center) {
            Image(likeStatus ? .likeFill : .likeEmpty)
                .basicImage(width: 24, color: likeStatus ? .scmBlackSprout : .scmGray45)
                .padding([.top, .leading], 5)
                .asButton {
                    likeButtonAction?()
                }
                .opacity(likeOpacity)
            
            Spacer()
            
            PickBadgeCell()
                .opacity(picchelinStatus ? 1 : 0)
        }
    }
}

extension View {
    func badgeOverlay(
        likeStatus: Bool,
        picchelinStatus: Bool,
        likeOpacity: Double,
        padding: CGFloat,
        likeButtonAction: (() -> ())?
    ) -> some View {
        modifier(
            BadgeOverlayModifier(
                likeStatus: likeStatus,
                picchelinStatus: picchelinStatus,
                likeOpacity: likeOpacity,
                padding: padding,
                likeButtonAction: likeButtonAction
            )
        )
    }
}
