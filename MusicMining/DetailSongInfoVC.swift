//
//  DetailSongInfoVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 29..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit

class DetailSongInfoVC: UIViewController, NetworkCallback {
    
    @IBOutlet var songInfoImage: UIImageView!
    @IBOutlet var songInfoTitle: UILabel!
    @IBOutlet var songInfoMusician: UILabel!
    @IBOutlet var songInfoLyrics: UITextView!
    
    @IBOutlet var musician: UILabel!
    @IBOutlet var title_musician: UILabel!
    @IBOutlet var composers: UILabel!
    
    @IBOutlet var lyricsView: UIView!
    @IBOutlet var readyLabel: UILabel!
    
    @IBOutlet var dot1: UIImageView!
    @IBOutlet var dot2: UIImageView!
    @IBOutlet var dot3: UIImageView!
    
    var btnFlag = 0
    var infoModel : DetailSongInfoModel!
    let sm = SessionModel()
    var music_id : Int!
    var infoSong : SongVO!
    var user_id : String!
    
    override func viewDidLoad() {
        initModel()
        initView()
    }

    func initView() {
        songInfoImage.roundedBorder()
        lyricsView.isHidden = false
        readyLabel.isHidden = true
        dot1.isHidden = false
        dot2.isHidden = true
        dot3.isHidden = true
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
                    default:
                        print("err")
                    }
                }
            }
        }
        songInfoTitle.text = getStringNonOptional(infoSong.title)
        songInfoImage.imageFromUrl(getStringNonOptional(infoSong.album_image_url), defaultImgPath: "")
        songInfoMusician.text = "\(singer) (\(getStringNonOptional(infoSong.album_name)))"
        musician.text = singer
        title_musician.text = "\(getStringNonOptional(infoSong.title)) - \(singer)"
        composers.text = lyricist + composer
        songInfoLyrics.text = getStringNonOptional(infoSong.lyrics)
    }
    
    override func getStringNonOptional(_ data : String?) -> String {
        if let data_ = data{
            return data_
        } else {
            return ""
        }
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

    // 카톡 링크 공유 기능
    @IBAction func kakaoShareBtn(_ sender: UIButton) {
        let text = "[새로운 음악의 발견] 도깨비 OST PART 3. HUSH - Lasse Lindh "
        let linkText = KakaoTalkLinkObject.createLabel(text)
        //let image = KakaoTalkLinkObject.createImage("https://s3.ap-northeast-2.amazonaws.com/noldam/sitter/certificate/pokemon1.png", width: 164, height: 198)
        let image = KakaoTalkLinkObject.createImage("hush", width: 164, height: 164)
        let appAction = KakaoTalkLinkAction.createAppAction(.IOS, devicetype: .phone, marketparamString: "itms-apps://itunes.apple.com/kr/app/noldam/id1137715307?mt=8", execparamString: "")!
        let link = KakaoTalkLinkObject.createAppButton("눌러보세요!!", actions: [appAction])
        KOAppCall.openKakaoTalkAppLink([linkText!, image!, link!])
    }
    
    @IBAction func tab1(_ sender: Any) {
        lyricsView.isHidden = false
        readyLabel.isHidden = true
        dot1.isHidden = false
        dot2.isHidden = true
        dot3.isHidden = true
    }
    
    @IBAction func tab2(_ sender: Any) {
        lyricsView.isHidden = true
        readyLabel.isHidden = false
        dot1.isHidden = true
        dot2.isHidden = false
        dot3.isHidden = true
    }
    
    @IBAction func tab3(_ sender: Any) {
        lyricsView.isHidden = true
        readyLabel.isHidden = false
        dot1.isHidden = true
        dot2.isHidden = true
        dot3.isHidden = false
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
