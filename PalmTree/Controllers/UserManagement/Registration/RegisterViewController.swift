//
//  RegisterViewController.swift
//  PalmTree
//
//  Created by SprintSols on 11/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegisterViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate, NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var txtName: UITextField! {
        didSet {
            txtName.delegate = self
        }
    }
    
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var txtConfirmPassword: UITextField! {
        didSet {
            txtConfirmPassword.delegate = self
        }
    }

    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var lblPass: UILabel!
    
    //MARK:- Properties
    
    var isAgreeTerms = false
    var page_id = ""
    var isVerifivation = false
    var isVerifyOn = false
    
    
    //MARK:- Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

//        self.registerData()
//        txtFieldsWithRtl()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            buttonRegister.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPassword.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtConfirmPassword.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtEmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPass.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
            txtName.textAlignment = .right
            txtConfirmPassword.textAlignment = .right
            lblText.textAlignment = .right
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtName {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            txtConfirmPassword.becomeFirstResponder()
        }
        else if textField == txtConfirmPassword {
            txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom
    func txtFieldsWithRtl()
    {
//        let attributedString = NSMutableAttributedString(string: txtView.text!)
        
//        let linkedText = NSMutableAttributedString(attributedString: attributedString)
//        let terms = linkedText.setAsLink(textToFind: "Terms of use", linkURL: "https://www.google.com/")
//        let privacy = linkedText.setAsLink(textToFind: "Privacy Policy", linkURL: "https://www.google.com/")
//        let offers = linkedText.setAsLink(textToFind: "third party offers", linkURL: "https://www.google.com/")
//
//        if terms && privacy && offers
//        {
//            txtView.attributedText = NSAttributedString(attributedString: linkedText)
//        }
        
//        if UserDefaults.standard.bool(forKey: "isRtl")
//        {
//            txtEmail.textAlignment = .right
//            txtPassword.textAlignment = .right
//            txtName.textAlignment = .right
//            txtConfirmPassword.textAlignment = .right
//        }
//        else
//        {
//            txtEmail.textAlignment = .left
//            txtPassword.textAlignment = .left
//            txtName.textAlignment = .left
//            txtConfirmPassword.textAlignment = .left
//        }
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }

    func populateData()
    {
        if UserHandler.sharedInstance.objregisterDetails != nil {
            let objData = UserHandler.sharedInstance.objregisterDetails
            
            if let isVerification = objData?.isVerifyOn {
                self.isVerifyOn = isVerification
            }

            if let bgColor = defaults.string(forKey: "mainColor") {
                self.buttonRegister.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                self.buttonRegister.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
            }
            
           
            if let nameText = objData?.namePlaceholder {
                self.txtName.placeholder = nameText
            }
            if let emailText = objData?.emailPlaceholder {
                self.txtEmail.placeholder = emailText
            }
            
            if let passwordtext = objData?.passwordPlaceholder {
                self.txtPassword.placeholder = passwordtext
            }
            
            
            if let isUserVerification = objData?.isVerifyOn {
                self.isVerifivation = isUserVerification
            }
            
            // Show hide guest button
            guard let settings = defaults.object(forKey: "settings") else {
                return
            }
            let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settings as! Data) as! [String : Any]
            let objSettings = SettingsRoot(fromDictionary: settingObject)
            
            
        }
    }
    
    func validpassword(password : String) -> Bool
    {
        let passwordreg =  ("(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: password)
    }
    
    func hideKeypad()
    {
        txtName.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        txtConfirmPassword.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeypad()
    }
    
    //MARK: -IBActions
    
    @IBAction func crossBtnAction(_ sender: Any)
    {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionRegister(_ sender: UIButton)
    {
        guard let name = txtName.text else {
            return
        }
        guard let email = txtEmail.text else {
            return
        }
        
        guard let password = txtPassword.text else {
            return
        }
        
        guard let confirmPassword = txtConfirmPassword.text else {
            return
        }
        
        if name == "" {
             self.txtName.shake(6, withDelta: 10, speed: 0.06)
        }
        else if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if validpassword(password: password)
        {
            self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        else if password != confirmPassword
        {
             self.txtConfirmPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
            let parameters : [String: Any] = [
                "name": name,
                "email": email,
                "phone": "",
                "password": password
            ]
            print(parameters)
            defaults.set(email, forKey: "email")
            defaults.set(password, forKey: "password")
            self.registerUser(param: parameters as NSDictionary)
        }
    }
    

    //MARK:- API Calls
    //Get Details Data
    func registerData() {
        self.showLoader()
        UserHandler.registerDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objregisterDetails = successResponse.data
                if let pageID = successResponse.data.termPageId {
                    self.page_id = pageID
                }
                self.populateData()
                
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- User Register
    func registerUser(param: NSDictionary) {
        self.showLoader()
        UserHandler.registerUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                if self.isVerifivation
                {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        confirmationVC.user_id = successResponse.data.id
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                   self.presentVC(alert)
                }
                else
                {
                    defaults.set(true, forKey: "isLogin")
                    
                    if myAdsVC != nil
                    {
                        myAdsVC.checkLogin()
                    }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM yyyy"
                    defaults.set(formatter.string(from: Date()), forKey: "joining")
                    
                    userDetail?.displayName = successResponse.data.displayName
                    userDetail?.id = successResponse.data.id
                    userDetail?.phone = successResponse.data.phone
                    userDetail?.profileImg = successResponse.data.profileImg
                    userDetail?.userEmail = successResponse.data.userEmail
                    
                    defaults.set(successResponse.data.displayName, forKey: "displayName")
                    defaults.set(successResponse.data.id, forKey: "id")
                    defaults.set(successResponse.data.phone, forKey: "phone")
                    defaults.set(successResponse.data.profileImg, forKey: "profileImg")
                    defaults.set(successResponse.data.userEmail, forKey: "userEmail")
                    
                    self.dismiss(animated: true, completion: nil)
                }
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

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound
        {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            self.addAttribute(NSAttributedStringKey.foregroundColor,value:UIColor(red: 58.0/255.0, green: 171.0/255.0, blue: 51.0/255.0, alpha: 1),range:foundRange)
            return true
        }
        return false
    }
}
