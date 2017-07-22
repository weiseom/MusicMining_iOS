//
//  VideoInfoViewVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2017. 1. 3..
//  Copyright © 2017년 Sopt. All rights reserved.
//


import UIKit

class VideoInfoViewVC: UIViewController {
    
    @IBOutlet var imgAlbum: UIImageView!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var songMusician: UILabel!
    @IBAction func songPlusBtn(_ sender: Any) {}
    
    override func viewDidLoad() {
        imgAlbum.roundedBorder()
    }
}
