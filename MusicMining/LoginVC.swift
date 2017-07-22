//
//  LoginVC.swift
//  MusicMining
//
//  Created by Minseo Seo on 2016. 12. 31..
//  Copyright © 2016년 Sopt. All rights reserved.
//


import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import UIKit

class LoginVC: UIViewController, NetworkCallback, UITextFieldDelegate {
    
    @IBOutlet var userId: UITextField!
    @IBOutlet var userPasswd: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var loginIndicator: UIActivityIndicatorView!
    
    let userDB : [String : String] = ["공유" : "sms"]
    let sm = SessionModel()
    var loginModel : LoginModel!
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        loginModel = LoginModel(self)
        userId.delegate = self
        userId.tag = 0
        userPasswd.delegate = self
        userPasswd.tag = 1
        styleWhiteTF(tf: userId)
        styleWhiteTF(tf: userPasswd)
        setKeyboardSetting()
    }

    // 로그인
    @IBAction func loginButton(_ sender: AnyObject) {
        loginModel = LoginModel(self)
        let id = getStringNonOptional(userId.text)
        let passwd = getStringNonOptional(userPasswd.text)
        loginModel.postDefaultLogin(user_id: id, passwd: passwd, case_: 1)
    }
    
    // 회원가입
    @IBAction func joinBtn(_ sender: AnyObject) {}
    
    // 네이버 로그인
    @IBAction func naverLoginBtn(_ sender: Any) {}
    
    // 페이스북 로그인
    @IBAction func facebookLoginBtn(_ sender: Any) {
        if let token = FBSDKAccessToken.current() {
            self.loginModel?.fetchFBProfile()
        } else {
            let loginManager = LoginManager()
            loginManager.logIn([ .publicProfile, .email], viewController: self) { loginResult in
                switch loginResult {
                case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                    self.loginIndicator.startAnimating()
                    self.loginModel?.fetchFBProfile()
                case .failed(_):
                    self.networkFailed()
                case .cancelled:
                    print("User cancelled login.")
                }
            }
        }
    }
    
    // 카톡 로그인
    @IBAction func kakaoLoginBtn(_ sender: Any) {
        loginModel?.fetchKakaoProfile()
    }
    
    @IBAction func unwindToLoginPage(_ sender: UIStoryboardSegue) {}
    
    func presentToHome(){
        if let hvc = storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as? BaseTabBarController{
            present(hvc, animated: true )
        }
    }
    
    func presentToBase(){
        if let bvc = storyboard?.instantiateViewController(withIdentifier: "Home") as? Home{
            present(bvc, animated: true )
        }
    }
    
    func networkResult(resultData: Any, code: Int) {
        loginIndicator.stopAnimating()
        switch code {
        // 디폴트 로그인 성공
        case LoginModel.CODE_LOGIN_DEFAULT :
            presentToBase()
        // sns 로그인 성공
        case LoginModel.CODE_LOGIN_SNS :
            presentToBase()
        default:
            print("err")
        }
    }
    
    override func networkFailed() {
        loginIndicator.stopAnimating()
    }
}

extension UIViewController{
    func displayAlert(title: String, message msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    // 회원 판별
    func memberOk(val : String, pin : String)->Bool{
        if val != pin {
            return false
        }else if val == pin{
            return true
        }
        return true
    }
    
    // 로그인 가능 여부
    func checkLogin(id : String?, val : String?, passwd : String?){
        // 에러 메시지 유형
        if val == nil {
            displayAlert(title: "Valid Error", message: "아이디가 유효하지 않습니다!")
            return
        } else if passwd!.isEmpty {
            displayAlert(title: "Password Error", message: "패스워드를 입력해주세요.")
            return
        }
        //        else if memberOk(val: val!, pin: passwd!) == false{
        //            displayAlert(title: "Password Error", message: "패스워드가 틀렸습니다.")
        //            return
        //        }else if memberOk(val: val!, pin: passwd!) == true{
        //
        //            // 로그인 가능 : id로 DB 검색하여 InfoPage로 로드
        //            if let infoVC = storyboard?.instantiateViewController(withIdentifier: "JoinInfoVC")as? JoinInfoVC{
        //                infoVC.idData = id!
        //                infoVC.passwdData = passwd!
        //                present(infoVC, animated: true )
        //            }
        //        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}


