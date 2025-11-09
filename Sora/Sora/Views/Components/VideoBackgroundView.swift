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
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerView = uiView as? PlayerUIView {
            playerView.updateVideo(videoName: videoName)
        }
    }
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var loopObserver: NSObjectProtocol?
    
    init(videoName: String) {
        super.init(frame: .zero)
        setupVideo(videoName: videoName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideo(videoName: String) {
        cleanup()
        
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Video not found: \(videoName)")
            return
        }

        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.isMuted = true
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2))
        
        layer.addSublayer(playerLayer)
        
        setupLoopObserver()
        
        player?.play()
    }
    
    func updateVideo(videoName: String) {
        setupVideo(videoName: videoName)
    }
    
    private func setupLoopObserver() {
        if let observer = loopObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        loopObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
    }
    
    private func cleanup() {
        player?.pause()
        
        if let observer = loopObserver {
            NotificationCenter.default.removeObserver(observer)
            loopObserver = nil
        }
        
        playerLayer.player = nil
        playerItem = nil
        player = nil
    }
    
    deinit {
        cleanup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

struct VideoBackgroundView: View {
    let videoName: String
    
    var body: some View {
        CustomVideoPlayer(videoName: videoName)
            .ignoresSafeArea(.all, edges: .all)
    }
}
