//
//  PlaylistModel.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 31..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import Alamofire
import SwiftyJSON
import FacebookCore

class PlaylistModel: NetworkModel {
    
    static let CODE_PL_GET = 0
    static let CODE_PL_POST = 1
    static let CODE_PL_DELETE = 2
    
    // GET : playlist 불러오기
    func getPlayList(user_id : String){
        Alamofire.request("\(baseURL)/playlists/\(user_id)").responseJSON() { res in
            switch res.result {
            case .success :
                if let value = res.result.value {
                    let data = JSON(value)
                    let array = data["data"]
                    var tempList = [SongVO]()
                    for item in array.arrayValue {
                        let svo = SongVO.init(music_id: item["music_id"].int, title: item["title"].string, musician_name: item["musician_name"].string, featuring_musician_name: item["featuring_musician_name"].string, album_image_url: item["album_image_url"].string)
                        tempList.append(svo)
                    }
                    self.view.networkResult(resultData: tempList, code: PlaylistModel.CODE_PL_GET)
                }
                break
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    }
    
    // GET : player 불러오기
    func getPlayerList(user_id : String){
        Alamofire.request("\(baseURL)/playlists/\(user_id)").responseJSON() { res in
            switch res.result {
            case .success :
                if let value = res.result.value {
                    let data = JSON(value)
                    let array = data["data"]
                    var tempList = [SongVO]()
                    for item in array.arrayValue {
                        let svo = SongVO.init(music_url: item["music_url"].string, music_id: item["music_id"].int, title: item["title"].string, musician_name: item["musician_name"].string, featuring_musician_name: item["featuring_musician_name"].string, album_image_url: item["album_image_url"].string)
                        tempList.append(svo)
                    }
                    self.view.networkResult(resultData: tempList, code: PlaylistModel.CODE_PL_GET)
                }
                break
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    }
    
    // POST : playlist에 음악 추가
    func uploadPlayList(user_id : String, music_id : Int) {
        let params = [
            "user_id" : user_id,
            "music_id" : music_id
        ] as [String : Any]
        Alamofire.request("\(baseURL)/playlists", method: .post, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: res.result, code: PlaylistModel.CODE_PL_POST)
                
            case .failure(let err) :
                print(err)
                self.view.networkFailed()
            }
        }
        
    }
    
    // DELETE : playlist의 음악 삭제
    func deletePlayList(user_id : String, music_id : Int) {
        let params = [
            "user_id" : user_id,
            "music_id" : music_id
        ] as [String : Any]
        Alamofire.request("\(baseURL)/playlists", method: .delete, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: "", code: PlaylistModel.CODE_PL_DELETE)
            case .failure(let err) :
                print(err)
                self.view.networkFailed()
            }
        }
    }    
}
