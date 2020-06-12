//
//  VerifyNumberController.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import JGProgressHUD

class VerifyNumberController: UIViewController, NVActivityIndicatorViewable {

    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var viewMsg: UIView! {
        didSet {
            viewMsg.circularView()
        }
    }
    @IBOutlet weak var imgMsg: UIImageView!
    
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOk: UIButton!
    @IBOutlet weak var buttonResend: UIButton!
    
    //MARK:- Properties
    var dataToShow = UserHandler.sharedInstance.objProfileDetails
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Verify Number Controller")
        self.populateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func populateData() {
        if dataToShow != nil {
            if let placeHolderText = dataToShow?.extraText.phoneDialog.textField {
                self.txtCode.placeholder = placeHolderText
            }
            if let cancelText = dataToShow?.extraText.phoneDialog.btnCancel {
                self.buttonCancel.setTitle(cancelText, for: .normal)
            }
            if let confirmText = dataToShow?.extraText.phoneDialog.btnConfirm {
                self.buttonOk.setTitle(confirmText, for: .normal)
            }
            if let resendText = dataToShow?.extraText.phoneDialog.btnResend {
                self.buttonResend.setTitle(resendText, for: .normal)
            }
        }
        else {
            
        }
    }

  
    //MARK:- IBActions
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func actionOk(_ sender: UIButton) {
        guard let codeField = txtCode.text else {
            return
        }
        if codeField == "" {
            
        }
        
        else {
            let parameter : [String: Any] = ["verify_code": codeField]
            print(parameter)
            self.verifyCode(parameter: parameter as NSDictionary)
        }
        
    }

    @IBAction func actionResend(_ sender: UIButton) {
        self.phoneNumberVerify()
    }
    
    //MARK:- API Call
    
    func verifyCode(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.verifyCode(param: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = successResponse.message as! String
                hud.detailTextLabel.text = nil
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.position = .bottomCenter
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
                self.perform(#selector(self.disMiss), with: nil, afterDelay: 2)
                UserDefaults.standard.set(true, forKey: "can")
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
    
    //send code
    
    func phoneNumberVerify() {
        self.showLoader()
        UserHandler.verifyPhone(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = successResponse.message as! String
                hud.detailTextLabel.text = nil
                hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                hud.position = .bottomCenter
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
                self.perform(#selector(self.disMiss), with: nil, afterDelay: 2)
                
                
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
    
    @objc func disMiss(){
        self.dismissVC(completion: nil)
    }

}







