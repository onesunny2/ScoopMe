//
//  AdBannerCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/22/25.
//

import SwiftUI
import SCMImageRequest

struct AdBannerCell: View {
    
    @State private var timer: Timer? = nil
    @State private var selectedTab = 0
    
    private let width = UIScreen.main.bounds.size.width
    
    let imageHelper: ImageHelper
    let banner: [String] = [
        Secret.baseURL + "/v1/data/stores/ante-samarzija-lsmu0rUhUOk-unsplash_1747128571997.jpg",
        Secret.baseURL + "/v1/data/stores/demi-deherrera-L-sm1B4L1Ns-unsplash_1747128572138.jpg",
        Secret.baseURL + "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg"
      ]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(banner.indices, id: \.self) { index in
                NukeRequestImageCell(
                    imageHelper: imageHelper,
                    url: banner[index],
                    topLeading: 0,
                    bottomLeading: 0,
                    bottomTrailing: 0,
                    topTrailing: 0
                )
                .frame(width: width, height: width * 0.26)
                .clipped()
                .overlay(alignment: .bottomTrailing) {
                    Text("\(index + 1) / \(banner.count)")
                        .basicText(.PTCaption2, .scmGray30)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.scmGray75.opacity(0.35))
                        }
                        .padding([.bottom, .trailing], 12)
                }
                .tag(index)
            }
        }
        .frame(width: width, height: width * 0.26)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: selectedTab) { _ in
            startTimer()
        }
    }
}

// MARK: method
extension AdBannerCell {
    
    private func updateTabViewIndex() async {
        await MainActor.run {
            withAnimation(.easeInOut(duration: 0.3)) {
                if selectedTab < banner.count - 1 {
                    selectedTab += 1
                } else {
                    selectedTab = 0
                }
            }
        }
    }
    
    /// 타이머
    private func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: true) { _ in
            Task { await updateTabViewIndex() }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
}
