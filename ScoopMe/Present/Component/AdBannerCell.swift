//
//  AdBannerCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/22/25.
//

import SwiftUI
import SCMImageRequest

struct AdBannerCell: View {
    
    private let width = UIScreen.main.bounds.size.width
    
    let imageHelper: ImageHelper
    let banner: [String] = [
        Secret.baseURL + "/v1/data/stores/ante-samarzija-lsmu0rUhUOk-unsplash_1747128571997.jpg",
        Secret.baseURL + "/v1/data/stores/demi-deherrera-L-sm1B4L1Ns-unsplash_1747128572138.jpg",
        Secret.baseURL + "/v1/data/stores/jeremy-yap-jn-HaGWe4yw-unsplash_1747128572373.jpg"
      ]
    
    var body: some View {
        TabView {
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
            }
        }
        .frame(width: width, height: width * 0.26)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    AdBannerCell(imageHelper: DIContainer.shared.imageHelper)
}
