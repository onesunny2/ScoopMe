//
//  StoreDetailModalCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/26/25.
//

import SwiftUI
import SCMScoopInfo

struct StoreDetailModalCell: View {
    
    let info: StoreDetailInfoEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            address
            parking
            manageTime
        }
        .padding(.vertical, 16)
        .defaultHorizontalPadding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.scmGray0.opacity(0.9))
        }
    }
}

// MARK: UI
extension StoreDetailModalCell {
    private var address: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(StringLiterals.가게주소.text)
                .basicText(.PTBody2, .scmGray75)
            
            HStack(alignment: .center, spacing: 4) {
                Image(.distance)
                    .basicImage(width: 20, color: .scmDeepSprout)
                Text(info.address)
                    .basicText(.PTBody2, .scmGray75)
            }
        }
    }
    
    private var parking: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(StringLiterals.주차여부.text)
                .basicText(.PTBody2, .scmGray75)
            
            HStack(alignment: .center, spacing: 4) {
                Image(.parking)
                    .basicImage(width: 20, color: .scmDeepSprout)
                Text(info.parkingInfo)
                    .basicText(.PTBody2, .scmGray75)
            }
        }
    }
    
    private var manageTime: some View {
        HStack(alignment: .center, spacing: 12) {
            Text(StringLiterals.영업시간.text)
                .basicText(.PTBody2, .scmGray75)
            
            HStack(alignment: .center, spacing: 4) {
                Image(.time)
                    .basicImage(width: 20, color: .scmDeepSprout)
                Text(info.time)
                    .basicText(.PTBody2, .scmGray75)
            }
        }
    }
}

// MARK: StringLiterals
private enum StringLiterals: String {
    case 가게주소
    case 주차여부
    case 영업시간
    
    var text: String {
        return self.rawValue
    }
}
