//
//  AudioPlayVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 30..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit
import AVFoundation

@objc protocol AudioPlayerVCDelegate {
    
    @objc optional func everySecond(_ player: AVAudioPlayer?)
}

class AudioPlayerVC: UIViewController, NetworkCallback, AVAudioPlayerDelegate {
    
    @IBOutlet var songImage: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var songMusician: UILabel!
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var defaultTitle: UILabel!
    
    weak var delegate: AudioPlayerVCDelegate? = nil
    var playFlag = 1
    var audioPlayer: AVAudioPlayer? = nil
    var url = [URL]()
    var soundDataList = [Data]()
    var songIndex : Int = 0
    var playModel : PlaylistModel!
    var sm = SessionModel()
    var musicId : Int!
    var userId : String!
    var playlist = [SongVO]()
    var timer = Timer()
    
    // Player button tag
    enum audioButtonTag: Int {
        case BUTTON_PLAY = 1000
        case BUTTON_PAUSE = 1001
        case BUTTON_PREVIOUS = 1002
        case BUTTON_NEXT = 1003
    }
    
    override func viewDidLoad() {
        initView()
        initModel()
        audioPlayer?.delegate = self
    }
    
    func initView() {
        songTitle.text = ""
        songMusician.text = ""
        songImage.image = UIImage(named: "final_logo")
        songImage.roundedBorder()
    }
    
    func initModel() {
        userId = sm.getID()
        playModel = PlaylistModel(self)
        playModel.getPlayerList(user_id: "test")
    }
    
    func playViewInit(songIndex : Int){
        songTitle.text = playlist[songIndex].title
        songImage.imageFromUrl(playlist[songIndex].album_image_url, defaultImgPath: "")
        songMusician.text = playlist[songIndex].musician_name
    }
    
    func playModelInit(){
        do {
            for item in playlist {
                if let url = URL(string : getStringNonOptional(item.music_url)){
                    let soundData = try Data(contentsOf: url)
                    soundDataList.append(soundData)
                }
            }
        } catch {
            print("실패")
        }
    }
    
    // 플레이어 생성
    func player(i : Int) -> AVAudioPlayer{
        do {
            if(i == url.count){
                songIndex = 0
            }
            audioPlayer = try AVAudioPlayer(data: soundDataList[songIndex])
            
            if let player = audioPlayer {
                player.prepareToPlay()
                return player
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return audioPlayer!
    }
    
    func playSongNowFromPlaylist(index : Int){
        defaultTitle.text = ""
        songIndex = index
        checkBtn()
        backgroundPlay()
        checkControll()
        do {
            audioPlayer = try AVAudioPlayer(data: soundDataList[index])
            playViewInit(songIndex : index)
            guard let player = audioPlayer else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playNextSong()
    }
    
    // 플레이리스트에 음악 추가
    func plusSong(musicId : Int!){
        playModel.uploadPlayList(user_id: "test", music_id: musicId)
    }
    
    // Controller : 재생, 정지, 다음 곡 재생
    @IBAction func audioControllerBtnClick(_ sender: UIButton) {
        backgroundPlay()
        defaultTitle.text = ""
        if(audioPlayer == nil){
            do {
                print(songIndex)
                audioPlayer = try AVAudioPlayer(data: soundDataList[songIndex])
                playViewInit(songIndex: songIndex)
                guard let player = audioPlayer else { return }
                player.prepareToPlay()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        switch (sender as AnyObject).tag {
        case audioButtonTag.BUTTON_PLAY.rawValue :
            if playFlag == 0 {
                playFlag = 1
                sender.setImage(UIImage(named: "button_play_with_fast_forward"), for: .normal)
                print("정지 : \(audioButtonTag.BUTTON_PAUSE.rawValue)")
                checkControll()
                audioPlayer?.pause()
                timer.invalidate()
            }else if playFlag == 1{
                playFlag = 0
                sender.setImage(UIImage(named: "button_pause"), for: .normal)
                print("재생 : \(audioButtonTag.BUTTON_PLAY.rawValue)")
                checkControll()
                audioPlayer?.play()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkEverySecond), userInfo: nil, repeats: true)
            }
        case audioButtonTag.BUTTON_PREVIOUS.rawValue :
            playPreviousSong()
        case audioButtonTag.BUTTON_NEXT.rawValue :
            playNextSong()
        default:
            print(audioPlayer!)
        }
    }
    
    func playPreviousSong(){
        checkBtn()
        print("이전 곡 재생 : \(audioButtonTag.BUTTON_PREVIOUS.rawValue)")
        checkControll()
        audioPlayer?.stop()
        songIndex = songIndex - 1
        if songIndex == -1 {
            songIndex = soundDataList.count-1
        }
        playViewInit(songIndex: songIndex)
        player(i: songIndex).play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkEverySecond), userInfo: nil, repeats: true)
    }
    
    func playNextSong(){
        checkBtn()
        print("다음 곡 재생 : \(audioButtonTag.BUTTON_NEXT.rawValue)")
        checkControll()
        audioPlayer?.stop()
        songIndex = songIndex + 1
        if songIndex == soundDataList.count{
            songIndex = 0
        }
        playViewInit(songIndex: songIndex)
        player(i: songIndex).play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkEverySecond), userInfo: nil, repeats: true)
    }
    
    func checkBtn(){
        if playFlag == 0 {
            playBtn.setImage(UIImage(named: "button_pause"), for: .normal)
        }
        else if playFlag == 1 {
            playFlag = 0
            playBtn.setImage(UIImage(named: "button_pause"), for: .normal)
        }
    }
    
    func checkEverySecond() {
        delegate?.everySecond?(audioPlayer)
    }
    
    func checkBadge(){
        let item = parent?.childViewControllers[0].childViewControllers[1].tabBarItem
        item?.badgeValue = "N"
        if #available(iOS 10.0, *) {
            item?.badgeColor = UIColor.black
        } else {
            print("err")
        }
    }
    
    func checkControll(){
        if let tvc = parent?.childViewControllers.first as? UITabBarController {
            print(tvc)
            if tvc.viewControllers!.count > 0 {
                let secondVC = tvc.viewControllers![0]
                print(secondVC)
                if let cvc = secondVC.childViewControllers.first?.childViewControllers[1] as? VideoCarouselView {
                    print(cvc)
                    if let vView = cvc.carouselView.currentItemView as? VideoView {
                        vView.pauseVideo()
                    }
                }
            }
        }
    }
    
    func backgroundPlay(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // Audio Url Initialize
    @IBAction func pushDetailPlay(_ sender: Any) {
        let vc = parent?.childViewControllers[0] as! UITabBarController
        let nvc = vc.childViewControllers[vc.selectedIndex] as! UINavigationController
        
        if let detailPlayVC = storyboard?.instantiateViewController(withIdentifier: "DetailSongPlayVC") as? DetailSongPlayVC {
            if let dsp = nvc.childViewControllers.last as? DetailSongPlayVC{
            }else{
                if let music = playlist[songIndex].music_id{
                    detailPlayVC.music_id = music
                }
                nvc.pushViewController(detailPlayVC, animated: true)
            }
        }
        if let dpvc = storyboard?.instantiateViewController(withIdentifier: "DetailSongPlayVC") as? DetailSongPlayVC{
            if let music = playlist[songIndex].music_id{
                dpvc.music_id = music
            }
        }
    }
    
    func networkResult(resultData: Any, code: Int) {
        switch code {
        case PlaylistModel.CODE_PL_GET:
            let item = resultData as! [SongVO]
            playlist = item
            playModelInit()
        case PlaylistModel.CODE_PL_POST:
            checkBadge()
            playModel.getPlayList(user_id: "test")
        default:
            print("err")
        }
    }
}
