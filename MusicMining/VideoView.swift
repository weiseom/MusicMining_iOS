//
//  VideoView.swift
//  MusicMining
//
//  Created by  noldam on 2017. 1. 3..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
    
    init(frame: CGRect, vvo: VideoVO) {
        super.init(frame: frame)
        initSubViews(vvo: vvo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var imgThumbnail: UIImageView!
    var playerView: UIView!
    var infoView: VideoInfoView!
    var player: AVPlayer?
    var addBtn: UIButton?
    
    func initSubViews(vvo: VideoVO) {
        imgThumbnail = UIImageView(frame: self.frame)
        
        let thumbnailURL = vvo.thumbnail_url == nil ? "" : vvo.thumbnail_url!
        let url = vvo.highlight_video_url == nil ? "" : vvo.highlight_video_url!
        
        imgThumbnail.imageFromUrl(thumbnailURL, defaultImgPath: "")
        playerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 169))
        infoView = VideoInfoView(frame: CGRect(x: 0, y: 169, width: 300, height: 48))
        
        playerView.alpha = 0
        if let url = URL(string: url) {
            player = AVPlayer(url: url)
            let layer = AVPlayerLayer(player: player)
            layer.frame = playerView.frame
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            playerView.layer.addSublayer(layer)
        }
        infoView.image.imageFromUrl(vvo.album_image_url, defaultImgPath: "")
        infoView.image.roundedBorder()
        if let title = vvo.title {
            infoView.title.text = title
        }
        if let musician = vvo.musician_name {
            infoView.musician.text = musician
        }
        addSubview(imgThumbnail)
        addSubview(infoView)
        addSubview(playerView)
        addBtn = infoView.addBtn
    }
    
    func playVideo() {
        playerView.fadeIn()
        player?.play()
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch {
        }
    }
    
    func pauseVideo() {
        playerView.fadeOut()
        player?.pause()
    }
    
}




