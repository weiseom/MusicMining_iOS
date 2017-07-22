//
//  LoginFindPwdVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 31..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit

class LoginFindPwdVC: UIViewController, UITextFieldDelegate, NetworkCallback {
    
    @IBOutlet var userIdForFindPasswd: UITextField!
    @IBOutlet var ready: UIImageView!
    @IBOutlet var userId: UITextField!
    @IBOutlet var popBtn: UIButton!
    
    // 로그인 모델
    var loginModel : LoginModel!
    var btnFlag = 0
    
    @IBAction func popBtn(_ sender: Any) {
        ready.isHidden = true
        presentToLogin()
    }
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        styleWhiteTF(tf: userIdForFindPasswd)
        setKeyboardSetting()
        ready.isHidden = true
        popBtn.isEnabled = false
    }
    
    @IBAction func findPasswdBtn(_ sender: Any) {
        loginModel = LoginModel(self)
        let id = getStringNonOptional(userId.text)
        loginModel.postFindPasswd(user_id: id)
        ready.isHidden = false
        popBtn.isEnabled = true
    }
    
    func presentToLogin(){
        if let lvc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            present(lvc, animated: true )
        }
    }
    
    func networkResult(resultData: Any, code: Int) {
        switch code {
        // 가입 성공
        case LoginModel.CODE_FIND_PW :
            print("가입성공")
        default:
            print("err")
        }
    }
}
