//
//  VideoBackgroundView.swift
//  Sora
//
//  Created by Chernokoz on 07.11.2025.
//

import SwiftUI
import AVKit
import AVFoundation

struct CustomVideoPlayer: UIViewRepresentable {
    let videoName: String
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoName: videoName)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    
    init(videoName: String) {
        super.init(frame: .zero)
        
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Video not found: \(videoName)")
            return
        }
        
        player = AVPlayer(url: url)
        player?.isMuted = true
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2)) 
        
        layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
        
        player?.play()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

struct VideoBackgroundView: View {
    let videoName: String
    
    var body: some View {
        ZStack {
            CustomVideoPlayer(videoName: videoName)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
