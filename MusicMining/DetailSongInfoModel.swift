//
//  DetailSongInfoModel.swift
//  MusicMining
//
//  Created by Minseo Seo on 2017. 1. 5..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import Alamofire
import SwiftyJSON

class DetailSongInfoModel: NetworkModel {
    
    static let CODE_PL_INFO_GET = 3
    static let CODE_PL_INFO_LIKE_POST = 4
    static let CODE_PL_INFO_DONOT_LIKE_DELETE = 5
    
    // GET : 디테일정보 불러오기
    func getDetailSongInfo(music_id : Int){
        Alamofire.request("\(baseURL)/musics/\(music_id)").responseJSON() { res in
            switch res.result {
            case .success :
                if let value = res.result.value {
                    let data = JSON(value)
                    let item = data["data"]
                    var comArray = [ComposerVO]()
                    if let array = data["data"]["composers"].array{
                        for vo in array {
                            let cvo = ComposerVO.init(role_num: self.getIntNonOptional(vo["role_num"].int),
                                            musician_id: self.getIntNonOptional(vo["musician_id"].int),
                                            musician_name: self.getStringNonOptional(vo["musician_name"].string))
                            comArray.append(cvo)
                        }
                    }
                    let dvo = SongVO.init(like: item["likes"].int,
                                          music_id : item["music_id"].int,
                                          title: item["title"].string,
                                          music_url: item["music_url"].string,
                                          album_image_url: item["album_image_url"].string,
                                          album_name: item["album_name"].string,
                                          lyrics: item["lyrics"].string,
                                          genre: item["genre"].string,
                                          cvo : comArray)
                    self.view.networkResult(resultData: dvo, code: DetailSongInfoModel.CODE_PL_INFO_GET)
                }
            case .failure(let err) :
                print(err)
                self.view.networkFailed()
                
            }
        }
    }
    
    // POST : like
    func postLike(user_id : String, music_id : Int) {
        let params = [
            "user_id" : user_id,
            "music_id" : music_id
            ] as [String : Any]
        Alamofire.request("\(baseURL)/musics", method: .post, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: "", code: DetailSongInfoModel.CODE_PL_INFO_LIKE_POST)
                
            case .failure(let err) :
                print(err)
                self.view.networkFailed()
            }
        }
    }
    
    
    // DELETE : 좋아요 취소 요청
    // 0: 성공, 1:실패, 2:중복된 데이터
    func deleteLike(user_id : String, music_id : Int) {
        let params = [
            "user_id" : user_id,
            "music_id" : music_id
            ] as [String : Any]
        Alamofire.request("\(baseURL)/musics", method: .delete, parameters: params , encoding: JSONEncoding.default).responseJSON() { res in
            switch res.result {
            case .success :
                self.view.networkResult(resultData: "", code: DetailSongInfoModel.CODE_PL_INFO_DONOT_LIKE_DELETE)
            case .failure(let err) :
                print(err)
                self.view.networkFailed()
            }
        }
    }    
}
