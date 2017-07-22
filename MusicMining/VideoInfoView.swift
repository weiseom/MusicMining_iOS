//
//  VideoInfoView.swift
//  MusicMining
//
//  Created by Minseo Seo on 2017. 1. 3..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import UIKit

@IBDesignable class VideoInfoView: UIView{
    
    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var musician: UILabel!
    @IBOutlet var addBtn: UIButton!
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        //xibSetup()
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        //xibSetup()
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("VideoInfoView", owner: self, options: nil)!.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
}
