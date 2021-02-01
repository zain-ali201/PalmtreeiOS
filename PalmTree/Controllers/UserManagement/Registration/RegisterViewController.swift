//
//  RegisterViewController.swift
//  PalmTree
//
//  Created by SprintSols on 11/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseStorage
import FirebaseDatabase

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
    
    var ref: DatabaseReference!
    //MARK:- Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
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
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
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
        else
        {
            let parameters : [String: Any] = [
                "name": name,
                "email": email,
                "password": password,
                "language": languageCode
            ]
            print(parameters)
            defaults.set(email, forKey: "email")
            defaults.set(password, forKey: "password")
            self.registerUser(param: parameters as NSDictionary)
        }
    }
    
    //MARK:- User Register
    func registerUser(param: NSDictionary) {
        self.showLoader()
        UserHandler.registerUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success == 1
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
                    userDetail?.userEmail = successResponse.data.userEmail
                    userDetail?.joining = successResponse.data.joining
                    
                    defaults.set(successResponse.data.displayName, forKey: "displayName")
                    defaults.set(successResponse.data.joining, forKey: "joining")
                    defaults.set(successResponse.data.id, forKey: "userID")
                    defaults.set(successResponse.data.userEmail, forKey: "userEmail")
                    
                    Auth.auth().createUser(withEmail: userDetail?.userEmail ?? "", password: "Sprint1234!") { (user, error) in
                        if error == nil {
                            self.ref = Database.database().reference()
//                            var data = NSData()
//                            data = UIImageJPEGRepresentation(UIImage(named: ""), 0.8)! as NSData
//                            let storageRef = Storage.storage().reference()
//                            let filePath = "\(Auth.auth().currentUser!.uid)/\("imgUserProfile")"
//                            let metaData = StorageMetadata()
//                            metaData.contentType = "image/jpg"
//                            storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
//                                if let error = error {
//                                    print(error.localizedDescription)
//                                    return
//                                }
//                            }
                            self.sendChatToken(chatToken: user?.user.uid ?? "")
                            print("User registered for chat")
                            self.ref.child("users").child((user?.user.uid)!).setValue(["username": ["Firstname": userDetail?.displayName, "Lastname": ""]])
                        }
                        else
                        {
                            print("User not registered for chat")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: NSLocalizedString(String(format: "something_%@", languageCode), comment: ""))
            self.presentVC(alert)
        }
    }
    
    func sendChatToken(chatToken: String) {
        
        if chatToken != ""
        {
            let param: [String: Any] = ["fc_token": chatToken, "user_id": userDetail?.id ?? 0]
            print(param)
            AddsHandler.sendFirebaseChatToken(parameter: param as NSDictionary, success: { (successResponse) in
                
                print(successResponse)
            }) { (error) in
                self.stopAnimating()
                let alert = Constants.showBasicAlert(message: NSLocalizedString(String(format: "something_%@", languageCode), comment: ""))
                self.presentVC(alert)
            }
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
