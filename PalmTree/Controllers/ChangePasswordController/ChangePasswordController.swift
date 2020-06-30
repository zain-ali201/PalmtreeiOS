//
//  ChangePasswordController.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class ChangePasswordController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var viewLock: UIView! {
        didSet {
            viewLock.circularView()
        }
    }
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var txtOldPassword: HoshiTextField! {
        didSet {
            txtOldPassword.delegate = self
        }
    }
    @IBOutlet weak var txtNewPassword: HoshiTextField! {
        didSet {
            txtNewPassword.delegate = self
        }
    }
    @IBOutlet weak var txtConfirmPassword: HoshiTextField! {
        didSet {
            txtConfirmPassword.delegate = self
        }
    }
    @IBOutlet weak var buttonUpdate: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    //MARK:- Properties
    
    var dataToShow = UserHandler.sharedInstance.objProfileDetails
    var defaults = UserDefaults.standard
    var passwordToSave = ""
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Change Password Controller")
        self.populateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtOldPassword {
            txtNewPassword.becomeFirstResponder()
        }
        else if textField == txtNewPassword {
            txtConfirmPassword.becomeFirstResponder()
        }
        else if textField == txtConfirmPassword {
            txtConfirmPassword.resignFirstResponder()
            self.updatePass()
        }
        return true
    }
    
    //MARK:- Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func populateData() {
        if dataToShow != nil {
            if let oldPass = dataToShow?.extraText.changePass.oldPass {
                self.txtOldPassword.placeholder = oldPass
            }
            if let newPass = dataToShow?.extraText.changePass.newPass {
                self.txtNewPassword.placeholder = newPass
            }
            if let confirmPass = dataToShow?.extraText.changePass.newPassCon {
                self.txtConfirmPassword.placeholder = confirmPass
            }
            if let updatetext = dataToShow?.extraText.saveBtn {
                self.buttonUpdate.setTitle(updatetext, for: .normal)
            }
            if let cancelText = dataToShow?.extraText.cancelBtn {
                self.buttonCancel.setTitle(cancelText, for: .normal)
            }
            
            if let mainColor = defaults.string(forKey: "mainColor"){
                self.buttonUpdate.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
                self.buttonCancel.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
            
        }
        else {
            
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func actionUpdate(_ sender: UIButton) {
        self.updatePass()
    }

    func updatePass()
    {
        guard let oldPassword = txtOldPassword.text  else {
            return
        }
        
        guard let newPassword = txtNewPassword.text else {
            return
        }
        
        guard let confirmPassword = txtConfirmPassword.text else {
            return
        }
        if oldPassword == "" {
            
        }
            
        else if newPassword == "" {
            
        }
        else if confirmPassword == "" {
            
        }
            
        else if newPassword != confirmPassword {
            let alert = Constants.showBasicAlert(message: (dataToShow?.extraText.changePass.errPass)!)
            self.presentVC(alert)
        }
            
        else {
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

    //MARK:- API Call

    func changePassword(param: NSDictionary) {
        self.showLoader()
        UserHandler.changePassword(parameter: param , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.defaults.set(self.passwordToSave, forKey: "password")
                    self.defaults.synchronize()
                    self.dismissVC(completion: nil)
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
