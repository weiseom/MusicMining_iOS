//
//  PlaylistContainerVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 30..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit

class PlaylistContainerVC: UIViewController {
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        checkBadge()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkBadge()
    }
    func checkBadge(){
        parent?.tabBarItem.badgeValue = nil
    } 
}
