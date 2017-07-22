//
//  MenuVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 28..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    @IBOutlet var ready: UIImageView!
    var btnFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ready.isHidden = true
    }
    
    @IBAction func popBtn(_ sender: Any) {
        if btnFlag == 0 {
            btnFlag = 1
            ready.isHidden = false
        }else if btnFlag == 1 {
            btnFlag = 0
            ready.isHidden = true
        }
    }
}
