//
//  TermsConditionsController.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class EditProfileVC: UIViewController, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmailText: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPwdText: UILabel!
    
    @IBOutlet weak var lblContactDetails: UILabel!
    @IBOutlet weak var lblNumberText: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblEmail1Text: UILabel!
    @IBOutlet weak var lblEmail1: UILabel!
    @IBOutlet weak var lblNameText: UILabel!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var btnAddPhone: UIButton!
    
    //PasswordView
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var lblChangePassText: UILabel!
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var lblPassText: UILabel!
    @IBOutlet weak var lblReq: UILabel!
    @IBOutlet weak var btnChangePass: UIButton!
    
    //ContactView
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var lblContactDetails1: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var lblReq1: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var editBtn1: UIButton!
    @IBOutlet weak var editBtn2: UIButton!
    
    var passwordToSave = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = userDetail?.displayName ?? ""
        lblDisplayName.text = userDetail?.displayName ?? ""
        lblEmail.text = userDetail?.userEmail ?? ""
        lblNumber.text = userDetail?.phone ?? ""
        txtFirstName.text = userDetail?.displayName ?? ""
        txtNumber.text = userDetail?.phone ?? ""
        lblEmail1.text = userDetail?.userEmail ?? ""
        
        if (userDetail?.phone.isEmpty)!
        {
            lblNumber.alpha = 0
            btnAddPhone.alpha = 1
        }
        else
        {
            lblNumber.alpha = 1
            btnAddPhone.alpha = 0
        }
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblNumber.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmailText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPwdText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblContactDetails.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblNumberText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail1Text.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblNameText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDisplayName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtNumber.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtNewPass.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtFirstName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtConfirmPass.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtCurrentPass.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblContactDetails1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblReq1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblReq.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblChangePassText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPassText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            editBtn1.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            editBtn2.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnChangePass.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnSave.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnAddPhone.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
           
            lblName.textAlignment = .right
            lblNumber.textAlignment = .right
            lblEmail.textAlignment = .right
            lblEmail1.textAlignment = .right
            
            txtNumber.textAlignment = .right
            txtNewPass.textAlignment = .right
            txtFirstName.textAlignment = .right
            txtConfirmPass.textAlignment = .right
            txtCurrentPass.textAlignment = .right
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- IBActions
   
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            passwordView.alpha = 1
            contactView.alpha = 0
        }
        else
        {
            passwordView.alpha = 0
            contactView.alpha = 1
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func crossBtnAction(_ sender: Any)
    {
        contactView.alpha = 0
        passwordView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func passBtnAction(_ sender: Any)
    {
        guard let oldPassword = txtCurrentPass.text  else {
            return
        }
        
        guard let newPassword = txtNewPass.text else {
            return
        }
        
        guard let confirmPassword = txtConfirmPass.text else {
            return
        }
        
        let alert = Constants.showBasicAlert(message: "")
        
        if oldPassword == ""
        {
            if languageCode == "ar"
            {
                alert.message = "الرجاء إدخال كلمة المرور الحالية"
            }
            else
            {
                alert.message = "Please enter your current password"
            }
            self.presentVC(alert)
        }
        else if newPassword == ""
        {
            if languageCode == "ar"
            {
                alert.message = "يرجى إدخال كلمة المرور الجديدة الخاصة بك"
            }
            else
            {
                alert.message = "Please enter your new password"
            }
            self.presentVC(alert)
        }
        else if confirmPassword == ""
        {
            if languageCode == "ar"
            {
                alert.message = "يرجى إدخال كلمة المرور للتأكيد"
            }
            else
            {
                alert.message = "Please enter password for confirmation"
            }
            self.presentVC(alert)
        }
        else if newPassword != confirmPassword
        {
            if languageCode == "ar"
            {
                alert.message = "كلمة السر غير متطابقة"
            }
            else
            {
                alert.message = "Password does not match"
            }
            self.presentVC(alert)
        }
        else
        {
            let param: [String: Any] = [
                "old_pass": oldPassword,
                "new_pass": newPassword,
                "new_pass_con" : confirmPassword
            ]
            print(param)
            self.passwordToSave = newPassword
            self.changePassword(param: param as NSDictionary)
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        guard let name = txtFirstName.text else {
            return
        }
        guard let phone = txtNumber.text else {
            return
        }
        
        let alert = Constants.showBasicAlert(message: "")
        
        if name == ""
        {
            if languageCode == "ar"
            {
                alert.message = "من فضلك ادخل اسمك الكامل"
            }
            else
            {
                alert.message = "Please enter your full name"
            }
            
            self.presentVC(alert)
        }
        else if phone == ""
        {
            if languageCode == "ar"
            {
                alert.message = "يرجى إدخال رقم الهاتف الخاص بك"
            }
            else
            {
                alert.message = "Please enter your contact number"
            }
            self.presentVC(alert)
        }
        else
        {
            let custom: [String: Any] = [
                "_sb_profile_facebook": "",
                "_sb_profile_twitter" : "",
                "_sb_profile_linkedin" : "",
                "_sb_profile_google-plus" : ""
            ]
            
            let parameters: [String: Any] = [
                "user_name": name,
                "phone_number": phone,
                "account_type": "individual",
                "location": "UAE",
                "user_introduction" : "Individual user",
                "social_icons": custom
            ]
            
            print(parameters)
            self.updateProfile(params: parameters as NSDictionary)
        }
    }

    //MARK:- API Call

    func changePassword(param: NSDictionary)
    {
        self.showLoader()
        UserHandler.changePassword(parameter: param , success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    defaults.set(self.passwordToSave, forKey: "password")
                    self.passwordView.alpha = 0
                })
                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func updateProfile(params: NSDictionary) {
        self.showLoader()
        UserHandler.profileUpdate(parameters: params, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "Palmtree", message: successResponse.message, okAction: {
                    self.contactView.alpha = 0
                    userDetail?.displayName = self.txtFirstName.text!
                    userDetail?.phone = self.txtNumber.text!
                    
                    defaults.set(userDetail?.displayName, forKey: "displayName")
                    defaults.set(userDetail?.phone, forKey: "phone")
                    
                    self.lblName.text = userDetail?.displayName ?? ""
                    self.lblDisplayName.text = userDetail?.displayName ?? ""
                    self.lblNumber.text = userDetail?.phone ?? ""
                })
                self.presentVC(alert)
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
}
