//
//  VideoPlayerCell.swift
//  ScoopMe
//
//  Created by Lee Wonsun on 5/29/25.
//

import SwiftUI
import AVKit

struct VideoPlayerCell: View {
    
    @State private var player: AVPlayer?
    @State private var isVisible: Bool = false
    
    let url: String
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                setupPlayer()
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            checkVisibility(geometry: geometry)
                        }
                        .onChange(of: geometry.frame(in: .global)) { _ in
                            checkVisibility(geometry: geometry)
                        }
                }
            )
            .onDisappear {
                cleanupPlayer()
            }
    }
}

// MARK: Action
extension VideoPlayerCell {
    private func setupPlayer() {
        guard let videoURL = URL(string: url) else { return }
        player = AVPlayer(url: videoURL)
    }
    
    private func checkVisibility(geometry: GeometryProxy) {
        let frame = geometry.frame(in: .global)
        let screenBounds = UIScreen.main.bounds
        
        // 셀이 화면에 50% 이상 보일 때만 재생
        let visibleHeight = min(frame.maxY, screenBounds.height) - max(frame.minY, 0)
        let cellHeight = frame.height
        let visibilityRatio = visibleHeight / cellHeight
        
        let newVisibility = visibilityRatio > 0.5
        
        if newVisibility != isVisible {
            isVisible = newVisibility
            handlePlayback()
        }
    }
    
    private func handlePlayback() {
        guard let player else { return }
        
        if isVisible { player.play() }
        else {
            player.pause()
            player.seek(to: .zero)  // 처음으로 되돌리기
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        player = nil
    }
}

//#Preview {
//    VideoPlayerCell()
//}
