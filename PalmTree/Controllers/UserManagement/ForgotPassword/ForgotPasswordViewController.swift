//
//  ForgotPasswordViewController.swift
//  PalmTree
//
//  Created by SprintSols on 12/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    //MARK:- Outlets
    
    @IBOutlet weak var emailField: UITextField! {
        didSet {
            emailField.delegate = self
        }
    }
    
    //MARK:- Properties
    var defaults = UserDefaults.standard
    var isFromVerification = false
    var user_id = 0
    
    //MARK:- Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        txtFieldsWithRtl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Text Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            emailField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom
    
    func txtFieldsWithRtl(){
        if UserDefaults.standard.bool(forKey: "isRtl") {
            emailField.textAlignment = .right
        } else {
            emailField.textAlignment = .left
        }
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- IBActions
    @IBAction func backButtonPressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func crossBtnACtion(_ sender: UIButton)
    {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton)
    {
        guard let email = emailField.text else {
            return
        }
        if email == ""
        {
            self.emailField.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
            let param: [String: Any] = ["email": email]
            print(param)
            self.userForgot(param: param as NSDictionary)
        }
    }
    
    //MARK:- API Call
    
    func forgotData()
    {
        self.showLoader()
        UserHandler.forgotDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success == true
            {
                UserHandler.sharedInstance.objForgotDetails = successResponse.data
            }
            else
            {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // User Forgot Password
    
    func userForgot(param: NSDictionary) {
        self.showLoader()
        UserHandler.forgotUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success == true {
                let alert = Constants.showBasicAlert(message: "An email on its way. Please check your inbox and login with your new password.")
                self.presentVC(alert)
                self.emailField.text = ""
                self.emailField.resignFirstResponder()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
