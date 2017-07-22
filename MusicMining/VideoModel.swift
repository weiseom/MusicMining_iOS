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

class VideoModel: NetworkModel {
    
    static let CODE_VIDEO = 10
    
    // GET : video 불러오기
    func getVideo(){
        Alamofire.request("\(baseURL)/movies").responseJSON() { res in
            switch res.result {
            case .success :
                if let value = res.result.value {
                    let data = JSON(value)
                    var tempList = [VideoVO]()
                    let array = data["data"].arrayValue
                    for item in array {
                        let svo = VideoVO.init(highlight_video_url: item["highlight_video_url"].string, thumbnail_url: item["thumbnail_url"].string, music_id: item["music_id"].int, title: item["title"].string, musician_name: item["musician_name"].string, album_name: item["album_name"].string, album_image_url: item["album_image_url"].string)
                        tempList.append(svo)
                    }
                    print("templist count = \(tempList.count)")
                    self.view.networkResult(resultData: tempList, code: VideoModel.CODE_VIDEO)
                    
                }
                break
            case .failure(let err) :
                self.view.networkFailed()
            }
        }
    } 
    
}
