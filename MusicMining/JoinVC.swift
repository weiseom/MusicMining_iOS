//
//  JoinVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 31..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit

class JoinVC: UIViewController, NetworkCallback, UITextFieldDelegate {
 
    @IBOutlet var userId: UITextField!
    @IBOutlet var userPasswd: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userBirth: UITextField!
    @IBOutlet var userGender: UITextField!
    @IBOutlet var joinButton: UIButton!
    
    var originColor : UIColor = UIColor.gray
    
    // 로그인 모델
    var loginModel : LoginModel!
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        loginModel = LoginModel(self)
        
        styleWhiteTF(tf: userId)
        styleWhiteTF(tf: userPasswd)
        styleWhiteTF(tf: userName)
        styleWhiteTF(tf: userBirth)
        styleWhiteTF(tf: userGender)
        setKeyboardSetting()
        ready.isHidden = true
        popBtn.isEnabled = false
    
    }
    
    
    @IBOutlet var ready: UIImageView!
    
    @IBOutlet var popBtn: UIButton!
    
    @IBAction func popBtn(_ sender: UIButton) {
        ready.isHidden = true
        presentToLogin()
    }
    
    func networkResult(resultData: Any, code: Int) {
        switch code {
        case LoginModel.CODE_REGISTER :
            print("가입 성공")
            print(resultData)
            ready.isHidden = false
            popBtn.isEnabled = true
        default :
            print("가입 실패")
        }
    }
    
    @IBAction func joinButton(_ sender: Any) {
        loginModel = LoginModel(self)
        
        let id = getStringNonOptional(userId.text)
        let passwd = getStringNonOptional(userPasswd.text)
        let name = getStringNonOptional(userName.text)
        let birth = getStringNonOptional(userBirth.text)
        let gender = getIntNonOptional(Int(getStringNonOptional(userGender.text)))
        
        let jvo = UserVO.init(user_id: id, passwd: passwd, name: name, gender: gender, birth: birth)
        
        loginModel.postRegister(object: jvo)

    }
    
    @IBAction func textfieldEditingChanged(_ sender: AnyObject) {
        possibleJoin()
    }
    
    
    // 가입 정보 텍스트 필드란을 모두 입력하고, 성별을 체크하였는지 확인하는 메소드
    func possibleJoin(){
        
        if (userId.text?.characters.count != 0 && userPasswd.text?.characters.count != 0  && userName.text?.characters.count != 0 && userBirth.text?.characters.count != 0){
            
            joinButton.isEnabled = true
            joinButton.backgroundColor = originColor
            
        }else{
            joinButton.isEnabled = false
            joinButton.backgroundColor = UIColor.gray
        }
    }

    
    func presentToLogin(){
        if let lvc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC{
            present(lvc, animated: true )
        }
    }
}
