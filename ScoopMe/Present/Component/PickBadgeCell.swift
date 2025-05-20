//
//  PickBadgeCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/20/25.
//

import SwiftUI

struct PickBadgeCell: View {
    var body: some View {
        InsetRibbonShape(notchDepth: 8)
            .fill(.scmBlackSprout)
            .frame(width: 70, height: 20)
            .overlay(alignment: .leading) {
                HStack(alignment: .center, spacing: 4) {
                    Image(.pickFill)
                        .basicImage(width: 12, color: .scmGray15)
                    Text(StringLiterals.title.text)
                        .basicText(.PTCaption2, .scmGray15)
                }
                .padding(.leading, 6)
            }
    }
}

private enum StringLiterals: String {
    case title = "픽슐랭"
    
    var text: String {
        return self.rawValue
    }
}

struct InsetRibbonShape: Shape {
    
    var cornerRadius: CGFloat = 10
    var notchDepth: CGFloat = 10
    
    func path(in rect: CGRect) -> Path {
        let notchDepth: CGFloat = notchDepth // 안쪽으로 파인 깊이
        let cornerRadius: CGFloat = cornerRadius // 좌측 모서리 radius
        let tipRadius: CGFloat = 3 // 뾰족한 모서리 살짝 둥글게
        
        var path = Path()
        
        // 반지름으로 좌측 상단 둥글게 시작
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        
        // 우측 상단 모서리까지 직선
        path.addLine(to: CGPoint(x: rect.maxX - notchDepth - tipRadius, y: rect.minY))
        
        // 우측 상단 모서리 살짝 둥글게
        path.addArc(
            center: CGPoint(x: rect.maxX - notchDepth - tipRadius, y: rect.minY + tipRadius),
            radius: tipRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(315),
            clockwise: false
        )
        
        // 우측 중앙 파인 부분으로 직선
        path.addLine(to: CGPoint(x: rect.maxX - notchDepth*2, y: rect.midY))
        
        // 우측 하단 모서리로 직선
        path.addLine(to: CGPoint(x: rect.maxX - notchDepth - tipRadius, y: rect.maxY - tipRadius))
        
        // 우측 하단 모서리 살짝 둥글게
        path.addArc(
            center: CGPoint(x: rect.maxX - notchDepth - tipRadius, y: rect.maxY - tipRadius),
            radius: tipRadius,
            startAngle: .degrees(45),
            endAngle: .degrees(90),
            clockwise: false
        )
        
        // 좌측 하단 직선 (둥근 모서리 시작점까지)
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        
        // 좌측 하단 둥근 모서리
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        // 좌측 측면
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        // 좌측 상단 둥근 모서리
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        return path
    }
}

#Preview {
    PickBadgeCell()
}
