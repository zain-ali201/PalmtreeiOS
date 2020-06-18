//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ChatVC: UIViewController
{   
    //MARK:- Properties
    @IBOutlet weak var txtChat: UITextField!
    @IBOutlet weak var bottom:NSLayoutConstraint!
    
    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.keyboardNotification(notification:)),
        name: NSNotification.Name.UIKeyboardWillChangeFrame,
        object: nil)
    }

//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        {
//            print(keyboardSize.height)
//            if self.bottom.constant == 0 {
//                self.bottom.constant = keyboardSize.height
//            }
//        }
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottom?.constant = 0.0
            } else {
                self.bottom?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    

    @objc func keyboardWillHide(notification: NSNotification)
    {
        if self.bottom.constant != 0 {
            self.bottom.constant = 0
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK:- Actions
    
    @IBAction func backBtnACtion(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        txtChat.resignFirstResponder()
    }
}
