
//
//  ViewController.swift
//  iCarousel
//
//  Created by Minseo Seo on 2017. 1. 1..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoCarouselView: UIViewController, iCarouselDelegate, iCarouselDataSource, NetworkCallback {
    
    @IBOutlet var carouselView: iCarousel!
    
    var videomodel : VideoModel!
    var playlistModel : PlaylistModel!
    var videolist = [VideoVO]()
    var numbers = [Int]()
    var count = 0
    
    override func viewDidDisappear(_ animated: Bool) {
        if let cv = carouselView.currentItemView as? VideoView{
            cv.pauseVideo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        videomodel = VideoModel(self)
        videomodel.getVideo()
    }
    
    override func viewDidLoad() {
        carouselView.type = .coverFlow
    }

    func plusSong(_ sender: UIButton){
        let index = sender.tag
        let vvo = videolist[index]
        
        if let player = audioPlayerVC {
            player.plusSong(musicId: getIntNonOptional(vvo.music_id))
        }
    }
    
    // how many items do you want to be inside of your Carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return count
    }
    
    // view for row at indexpath
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let vvo = videolist[index]
        let tempView = VideoView(frame: CGRect(x: 0, y: 0, width: 300, height: 217), vvo: vvo)
        tempView.addBtn?.tag = index
        tempView.addBtn?.addTarget(self, action: #selector(plusSong(_:)), for: .touchUpInside)
        
        return tempView
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        let index = carousel.currentItemIndex
        if videolist.count > 0 {
            
            if index > 0 {
                if let leftView = carousel.itemView(at: index - 1) as? VideoView {
                    leftView.pauseVideo()
                }
            }
            
            if index < videolist.count {
                if let rightView = carousel.itemView(at: index + 1) as? VideoView {
                    rightView.pauseVideo()
                }
            }
            
            if let vView = carousel.currentItemView as? VideoView {
                vView.playVideo()
                audioPlayerVC?.audioPlayer?.pause()
            }
        }
    }
    
    // bunch of options to edit your Carousel to make it your own
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            
            // spacing between carousel views
            return value * 1.1
        }
        //else if option == iCarouselOption.fadeMax
        // => whatever you want, up to you
        
        return value
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func networkResult(resultData: Any, code: Int) {
        switch code {
        case 0:
            print(code)
        case VideoModel.CODE_VIDEO :
            let item = resultData as! [VideoVO]
            videolist = item
            numbers = [1,2,3,4,5,6]
            count = videolist.count
            carouselView.reloadData()
        case 2:
            print(code)
        default:
            print("err")
        }
    }
}

