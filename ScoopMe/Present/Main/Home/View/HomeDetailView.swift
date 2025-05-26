//
//  HomeDetailView.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/19/25.
//

import SwiftUI
import SCMLogger
import SCMScoopInfo

struct HomeDetailView: View {
    
    @StateObject private var repository: AnyStoreDetailDisplayable
    
    let storeID: String
    
    @State private var storeInfos: StoreDetailInfoEntity?
    
    init(repository: AnyStoreDetailDisplayable, storeID: String) {
        self._repository = StateObject(wrappedValue: repository)
        self.storeID = storeID
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            imageTabview
        }
        .ignoresSafeArea()
        .task {
            await getStoreDetailInfo()
        }
        .backButton(.scmGray0)
        .toolbarItem (trailing: {
            Image((storeInfos?.likeStatus ?? false) ? .likeFill : .likeEmpty)
                .basicImage(width: 32, color: .scmGray0)
        })
    }
}

// MARK: UI
extension HomeDetailView {
    private var imageTabview: some View {
        TabView {
            ForEach(storeInfos?.imageUrls ?? [], id: \.self) { url in
                NukeRequestImageCell(
                    imageHelper: DIContainer.shared.imageHelper,
                    url: url,
                    topLeading: .zero,
                    bottomLeading: .zero,
                    bottomTrailing: .zero,
                    topTrailing: .zero
                )
            }
        }
        .tabViewStyle(.page)
        .frame(maxWidth: .infinity, minHeight: 240)
    }
}

// MARK: Action
extension HomeDetailView {
    private func getStoreDetailInfo() async {
        do {
            let info = try await repository.getStoreDetailInfo(id: storeID)
            self.storeInfos = info
        } catch {
            await repository.checkTokenValidation(error) {
                let info = try await repository.getStoreDetailInfo(id: storeID)
                self.storeInfos = info
            }
            
            Log.error("❎ store detail info 통신 실패: \(error)")
        }
    }
}

#Preview {
    HomeDetailView(
        repository: DIContainer.shared.storeDetailRepository,
        storeID: "storeID 예시"
    )
}
