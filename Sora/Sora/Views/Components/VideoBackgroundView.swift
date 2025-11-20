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
    let isRotated: Bool
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(videoName: videoName, isRotated: isRotated)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerView = uiView as? PlayerUIView {
            if playerView.currentVideoName != videoName || playerView.isRotated != isRotated {
                 playerView.updateVideo(videoName: videoName, isRotated: isRotated)
            }
        }
    }
}

class PlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var loopObserver: NSObjectProtocol?
    
    var currentVideoName: String?
    var isRotated: Bool
    
    init(videoName: String, isRotated: Bool) {
        self.isRotated = isRotated
        super.init(frame: .zero)
        self.currentVideoName = videoName
        setupVideo(videoName: videoName, isRotated: isRotated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVideo(videoName: String, isRotated: Bool) {
        cleanup()
        
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            print("Video not found: \(videoName)")
            return
        }
        
        if let urls = Bundle.main.urls(forResourcesWithExtension: "mp4", subdirectory: nil) {
             for url in urls {
                 print("Bundle mp4: \(url.lastPathComponent)")
             }
         }

        self.currentVideoName = videoName
        self.isRotated = isRotated
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.isMuted = true
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        
        if isRotated {
            playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi / 2))
        } else {
            playerLayer.setAffineTransform(.identity)
        }
        
        layer.addSublayer(playerLayer)
        
        setupLoopObserver()
        
        player?.play()
    }
    
    func updateVideo(videoName: String, isRotated: Bool) {
        setupVideo(videoName: videoName, isRotated: isRotated)
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
    let isRotated: Bool
    
    var body: some View {
        CustomVideoPlayer(videoName: videoName, isRotated: isRotated)
            .ignoresSafeArea(.all, edges: .all)
    }
}
