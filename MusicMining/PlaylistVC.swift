//
//  PlaylistVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 28..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit

class PlaylistVC: UITableViewController, NetworkCallback {
    
    var playlist = [SongVO]()
    var playModel : PlaylistModel!
    var dataTitle : String!
    var dataMusician : String!
    
    override func viewDidLoad() {
        playlist.append(SongVO.init(music_id: 24, title: "네트워크 오류", musician_name: "f", featuring_musician_name: "dd", album_image_url: "dd"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playModel = PlaylistModel(self)
        playModel.getPlayList(user_id: "test")
    }
    
    func playSong(_ sender : UIButton){
        let index = sender.tag
        if let player = audioPlayerVC {
            player.playSongNowFromPlaylist(index: index)
        }
    }
    
    func networkResult(resultData: Any, code: Int) {
        switch code {
        case PlaylistModel.CODE_PL_GET:
            let item = resultData as! [SongVO]
            playlist = item
        case PlaylistModel.CODE_PL_POST:
            playModel.getPlayList(user_id: "test")
        case PlaylistModel.CODE_PL_DELETE:
            print(code)
        default:
            print(code)
        }
        tableView.reloadData()
    }
    
}

extension PlaylistVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell") as! PlaylistCell
        let item = playlist[indexPath.row]
        
        if let image = item.album_image_url {
            cell.songImage.imageFromUrl(image, defaultImgPath: "")
            cell.songImage.roundedBorder()
        }
        if let title = item.title{
            cell.songTitle.text = title
        }
        if let musician = item.musician_name{
            if let feat = item.featuring_musician_name {
                let str = musician + feat
                cell.songMusician.text = str
            }
        }
        cell.playBtn?.tag = indexPath.row
        cell.playBtn?.addTarget(self, action: #selector(playSong(_:)), for: .touchUpInside)
        
        return cell
    }
    
    // select event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = playlist[indexPath.row]
        if let detailSongVC = storyboard?.instantiateViewController(withIdentifier: "DetailSongInfoVC") as? DetailSongInfoVC{
            if let music = item.music_id{
                detailSongVC.music_id = music
            }
            navigationController?.pushViewController(detailSongVC, animated: true)
        }
    }
    
    // cell delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = getIntNonOptional(playlist[indexPath.row].music_id)
            print(id)
            playModel = PlaylistModel(self)
            playModel.deletePlayList(user_id: "test", music_id: id)
            self.playlist.remove(at: indexPath.row)
        } else if editingStyle == .insert {
            print("err")
        }
        tableView.reloadData()
    }
}
