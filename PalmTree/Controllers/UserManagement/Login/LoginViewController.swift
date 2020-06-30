//
//  LoginViewController.swift
//  PalmTree
//
//  Created by SprintSols on 9/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import NVActivityIndicatorView
import SDWebImage
import UITextField_Shake
import AuthenticationServices
import CryptoKit
import Firebase
import AuthenticationServices
import LinkedinSwift

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, GIDSignInUIDelegate, GIDSignInDelegate, UIScrollViewDelegate{
    
    //MARK:- Outlets
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.isScrollEnabled = true
        }
    }
    @IBOutlet weak var containerViewImage: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var buttonForgotPassword: UIButton!
    
    @IBOutlet weak var buttonSubmit: UIButton! {
        didSet {
            buttonSubmit.roundCorners()
        }
    }
    
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var btnGmail: UIButton!
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var lblSignupBtn: UILabel!
    
    
    //MARK:- Properties
    var getLoginDetails = [LoginData]()
    var isVerifyOn = false
    let loginManager = LoginManager()
    
    var accessToken: LISDKAccessToken?

    // MARK: Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboard()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //self.loginDetails()
        txtFieldsWithRtl()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblOr.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnFb.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnGmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSignup.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSignupBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            buttonForgotPassword.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            buttonSubmit.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtEmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPassword.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        self.loginDetails()
    }
    
    func fbLogin()
    {
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nothing")
            }
            else if (result?.isCancelled)! {
                print("Cancel")
            }
            else if error == nil {
                self.userProfileDetails()
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        defaults.removeObject(forKey: "isGuest")
        defaults.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- text Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            txtPassword.resignFirstResponder()
            self.logIn()
        }
        return true
    }
    
    //MARK: - Custom
    
    func txtFieldsWithRtl(){
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
        } else {
            txtEmail.textAlignment = .left
            txtPassword.textAlignment = .left
        }
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func populateData()
    {
        if UserHandler.sharedInstance.objLoginDetails != nil
        {
            let objData = UserHandler.sharedInstance.objLoginDetails
            
            if let isVerification = objData?.isVerifyOn {
                self.isVerifyOn = isVerification
            }
            
            if let emailPlaceHolder = objData?.emailPlaceholder {
                self.txtEmail.placeholder = emailPlaceHolder
            }
            if let passwordPlaceHolder = objData?.passwordPlaceholder {
                self.txtPassword.placeholder = passwordPlaceHolder
            }
            if let forgotText = objData?.forgotText {
                self.buttonForgotPassword.setTitle(forgotText, for: .normal)
            }
            if let submitText = objData?.formBtn {
                self.buttonSubmit.setTitle(submitText, for: .normal)
            }
        }
    }
    
    //MARK:- IBActions
  
    @IBAction func crossBtnAction(_ sender: Any)
    {
        self.navigationController?.dismiss(animated: true) 
    }
    
    @IBAction func actionForgotPassword(_ sender: Any)
    {
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: Any)
    {
        self.logIn()
    }
    
    @IBAction func actionLinkedinSubmit(_ sender: Any)
    {
         let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "Enter your LinkedIn clientId here", clientSecret: "Enter your LinkedIn clientSecret here", state: "dwweewg43v", permissions: ["r_liteprofile", "r_emailaddress"], redirectUrl: "Enter your LinkedIn redirectUrl here"),nativeAppChecker: WebLoginOnly())
        linkedinHelper.authorizeSuccess({ (token) in

                print(token)

                let url = "https://api.linkedin.com/v2/me"
                linkedinHelper.requestURL(url, requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                  let dict = response.jsonObject
                  print(dict!)
                  let weatherArray = dict!["profilePicture"] as? [String:Any]
                    print(weatherArray)
                    let imgProfile = weatherArray as? [String:Any]
                    let linkedinImg = imgProfile!["displayImage"]
                        print(linkedinImg)
                
                   let emailurl = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))"
                    linkedinHelper.requestURL(emailurl, requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                        print(response)
                        let dict = response.jsonObject
                        print(dict!)
                        if let weatherArray = dict!["elements"] as? [[String:Any]],
                           let weather = weatherArray.first {
                            let handle = weather["handle~"]
                               print(handle)
                            let email = handle as? [String:Any]
                            let emilaagay = email!["emailAddress"]
                            print(emilaagay)
                            let param: [String: Any] = [
                                "email":emilaagay!,
                                "type":"social",
                                "profile_img":linkedinImg!
                            ]
                            print(param)
                            defaults.set(true, forKey: "isSocial")
                            defaults.set(emilaagay, forKey: "email")
                            defaults.set("1122", forKey: "password")
                            defaults.synchronize()
                            self.loginUser(parameters: param as NSDictionary)
                            // the value is an optional.
                        }
                    })

                }) {(error) -> Void in
                    print(error.localizedDescription)
                    //handle the error
            }
        }, error: { (error) -> Void in
            //Encounter error: error.localizedDescription
        }, cancel: { () -> Void in
            //User Cancelled!
        })
    }
    
    func logIn() {
        guard let email = txtEmail.text else {
            return
        }
        guard let password = txtPassword.text else {
            return
        }
        if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if password == "" {
            self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
            let param : [String : Any] = [
                "email" : email,
                "password": password
            ]
            print(param)
            defaults.set(email, forKey: "email")
            defaults.set(password, forKey: "password")
            self.loginUser(parameters: param as NSDictionary)
        }
    }
    
    
    
    //    @IBAction func actionFBLogin(_ sender: UIButton) {
    //
    //        fbLogin()
    //
    //    }
    //
    
    @IBAction func btnLoginfBoK(_ sender: UIButton) {
        fbLogin()
    }
    
    @IBAction func actionGoogleLogin(_ sender: Any)
    {
        if GoogleAuthenctication.isLooggedIn {
            GoogleAuthenctication.signOut()
        }
        else {
            GoogleAuthenctication.signIn()
        }
    }
    
    @IBAction func actionGuestLogin(_ sender: Any) {
        defaults.set(true, forKey: "isGuest")
        self.showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            let homeVC = self.storyboard!.instantiateViewController(withIdentifier: HomeController.className) as! HomeController
//            self.navigationController?.pushViewController(homeVC, animated: true)
//            self.navigationController?.popToViewController(homeVC, animated: false)
            self.stopAnimating()
        }
    }
    
    @IBAction func actionRegisterWithUs(_ sender: Any) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK:- Google Delegate Methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error
        {
            print(error.localizedDescription)
        }
        
        if error == nil
        {
            guard let email = user.profile.email,
                let googleID = user.userID,
                let name = user.profile.name
                else { return }
            guard let token = user.authentication.idToken else {
                return
            }
            print("\(email), \(googleID), \(name), \(token)")
            let param: [String: Any] = [
                "email": email,
                "type": "social"
            ]
            print(param)
            defaults.set(true, forKey: "isSocial")
            defaults.set(email, forKey: "email")
            defaults.set("1122", forKey: "password")
            defaults.synchronize()
            self.loginUser(parameters: param as NSDictionary)
        }
    }
    // Google Sign In Delegate
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Facebook Delegate Methods
    
    func userProfileDetails()
    {
        if (AccessToken.current != nil) {
            GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else {
                    guard let results = result as? NSDictionary else { return }
                    guard let facebookId = results["email"] as? String,
                        let email = results["email"] as? String else {
                            return
                    }
                    print("\(email), \(facebookId)")
                    let param: [String: Any] = [
                        "email": email,
                        "type": "social"
                    ]
                    print(param)
                    defaults.set(true, forKey: "isSocial")
                    defaults.set(email, forKey: "email")
                    defaults.set("1122", forKey: "password")
                    defaults.synchronize()
                    
                    self.loginUser(parameters: param as NSDictionary)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton!) -> Bool {
        return true
    }
    
    //MARK:- API Calls
    
    //Login Data Get Request
    func loginDetails() {
        self.showLoader()
        UserHandler.loginDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objLoginDetails = successResponse.data
                self.populateData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // Login User
    func loginUser(parameters: NSDictionary)
    {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                defaults.set(true, forKey: "isLogin")
                
                if myAdsVC != nil
                {
                    myAdsVC.checkLogin()
                }
                
                if settingsVC != nil
                {
                    settingsVC.checkLogin()
                }
                
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
}

class User
{
    typealias JSON = [String: Any]
    var id: String?
    var firstName: String?
    var lastName: String?

    init(json: JSON)
    {
        guard let id = json["id"] as? String, let firstName = json["firstName"] as? String, let lastName = json["lastName"] as? String else { return }

        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
