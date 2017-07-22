//
//  BaseTabBarController.swift
//  MusicMining
//
//  Created by Minseo Seo on 2017. 1. 2..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        selectedIndex = defaultIndex
    }
}
