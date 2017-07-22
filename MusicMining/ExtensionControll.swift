//
//  ExtensionControll.swift
//  seminar_6_1
//
//  Created by Minseo Seo on 2016. 11. 26..
//  Copyright © 2016년 Sopt. All rights reserved.
//

import UIKit
import Kingfisher

extension UIViewController {
    func getStringNonOptional(_ value : String?) -> String {
        if let value_ = value{
            return value_
        } else {
            return ""
        }
    }
    
    func getIntNonOptional(_ value : Int? ) -> Int {
        if let value_ = value {
            return value_
        }else {
            return 0
        }
    }
    
    func getBoolNonOptional(_ value : Bool? ) -> Bool {
        if let value_ = value {
            return value_
        }else {
            return false
        }
    }
    
    func simpleAlert(title : String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func networkFailed() {
        simpleAlert(title: "네트워크 오류", msg: "인터넷 연결을 확인해주세요.")
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
            else {
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
            else {
            }
        }
    }
    
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    var audioPlayerVC : AudioPlayerVC? {
        if let cvcList = tabBarController?.parent?.childViewControllers  {
            print(cvcList)
            if cvcList.count > 0 {
                if let avc = cvcList[1] as? AudioPlayerVC {
                    return avc
                }
            }
        } 
        return nil
    }
}

extension UIImageView {
    public func imageFromUrl(_ urlString: String?, defaultImgPath : String) {
        let defaultImg = UIImage(named: defaultImgPath)
        if let url = urlString {
            if url.isEmpty {
                self.image = defaultImg
            } else {
                self.kf.setImage(with: URL(string: url), placeholder: defaultImg, options: [.transition(ImageTransition.fade(0.5))])
            }
        } else {
            self.image = defaultImg
        }
    }
    
    func roundedBorder() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    
}

extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
}

extension UITextFieldDelegate {
    func styleWhiteTF(tf : UITextField){
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder!,
                                                      attributes: [NSForegroundColorAttributeName: UIColor.init(white: 1, alpha: 0.5)])
    }
    
    func styleGrayTF(tf : UITextField){
        tf.attributedPlaceholder = NSAttributedString(string: tf.placeholder!,
                                                      attributes: [NSForegroundColorAttributeName: UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)])
    }
}


