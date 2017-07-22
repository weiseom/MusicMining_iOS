//
//  SearchVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2017. 1. 5..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var searchTf: UITextField!
    override func viewDidLoad() {
        styleGrayTF(tf: searchTf)
    }
}
