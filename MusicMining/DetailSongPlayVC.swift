//
//  DetailSongPlayVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 29..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailSongPlayVC: UIViewController, AudioPlayerVCDelegate, NetworkCallback {
    
    @IBOutlet var albumImg: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var musician: UILabel!
    @IBOutlet var lyrics: UITextView!
    
    let sm = SessionModel()
    var infoModel : DetailSongInfoModel!
    var btnFlag = 0
    var user_id : String!
    var music_id : Int!
    var infoSong : SongVO!
    
    override func viewDidLoad() {
        audioPlayerVC?.delegate = self
        initModel()
        initView()
    }
    
    func initView() {
        albumImg.roundedBorder()
    }
    
    func initModel() {
        user_id = sm.getID()
        infoModel = DetailSongInfoModel(self)
        infoModel.getDetailSongInfo(music_id: music_id)
    }
    
    func songViewInit(){
        //1 : 가수, 2 : 작곡가, 3 : 작사가, 4 : 피처링
        var singer = ""
        var lyricist = ""
        var composer = ""
        var feat = ""
        
        if let comArray = infoSong.cvo {
            for co in comArray{
                if let num = co.role_num {
                    switch num {
                    case 1:
                        singer = getStringNonOptional(co.musician_name)
                    case 2:
                        lyricist = "작사 : \(getStringNonOptional(co.musician_name))  |  "
                    case 3:
                        composer = "작곡 : \(getStringNonOptional(co.musician_name)) "
                    case 4:
                        feat = " (feat.\(getStringNonOptional(co.musician_name))"
                    default :
                        print("init view error")
                    }
                }
            }
        }
        albumImg.imageFromUrl(getStringNonOptional(infoSong.album_image_url), defaultImgPath: "")
        songTitle.text = getStringNonOptional(infoSong.title)
        musician.text = singer
        lyrics.text = getStringNonOptional(infoSong.lyrics)
    }
    
    func everySecond(_ player: AVAudioPlayer?) {
        //player?.play(atTime: <#T##TimeInterval#>)
        print(player?.currentTime)
    }
    
    @IBAction func likeBtn(_ sender: UIButton) {
        // 좋아요
        if btnFlag == 0 {
            btnFlag = 1
            infoModel.postLike(user_id: user_id, music_id: infoSong.music_id!)
            sender.setBackgroundImage(UIImage(named: "button_redlike"), for: .normal)
        }
        // 좋아요 취소
        else if btnFlag == 1 {
            btnFlag = 0
            infoModel.deleteLike(user_id: user_id, music_id: infoSong.music_id!)
            sender.setBackgroundImage(UIImage(named: "button_like"), for: .normal)
        }
    }
    
    @IBAction func previousDismiss(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func networkResult(resultData: Any, code: Int) {
        switch code {
        case DetailSongInfoModel.CODE_PL_INFO_GET :
            if let item = resultData as? SongVO{
                infoSong = item
            }
            songViewInit()
        default:
            print("err")
        }
    }
}
