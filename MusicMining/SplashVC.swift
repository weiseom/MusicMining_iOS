//
//  SplashVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2017. 1. 3..
//  Copyright © 2017년 Sopt. All rights reserved.
//

import UIKit

class SplashVC : UIViewController{
    
    let sm = SessionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentTo()
    }
    
    func presentTo() {
        if sm.getID() == "" {
            presentToLogin()
        }
        else {
            presentToLogin()
            //presentToHome()
        }
    }
    func presentToHome(){
        if let hvc = storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as? BaseTabBarController{
            present(hvc, animated: true )
        }
    }
    
    func presentToLogin(){
        if let lvc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            present(lvc, animated: true )
        }
    }
}
