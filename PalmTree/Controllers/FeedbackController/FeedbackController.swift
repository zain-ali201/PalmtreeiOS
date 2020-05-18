//
//  FeedbackController.swift
//  PalmTree
//
//  Created by SprintSols on 9/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import UITextField_Shake
import NVActivityIndicatorView

class FeedbackController: UIViewController, NVActivityIndicatorViewable, UITextViewDelegate {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
            containerView.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var lblFeedback: UILabel! {
        didSet {
            lblFeedback.layer.cornerRadius = 5
            lblFeedback.clipsToBounds = true
            if let mainColor = defaults.string(forKey: "mainColor") {
                lblFeedback.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtDescription: UITextView! {
        didSet {
            txtDescription.delegate = self
            txtDescription.layer.borderColor = UIColor.lightGray.cgColor
            txtDescription.layer.borderWidth = 0.5
        }
    }
    
    @IBOutlet weak var oltCancel: UIButton! {
        didSet{
            oltCancel.roundCornors()
            if let mainColor = defaults.string(forKey: "mainColor") {
                oltCancel.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var oltSubmit: UIButton! {
        didSet {
            oltSubmit.roundCornors()
            if let mainColor = defaults.string(forKey: "mainColor") {
                oltSubmit.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    
    var formData: AppSettingForm?
    var feedbackTitle = ""
    let defaults = UserDefaults.standard
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateData()
    }
    
    //MARK:- Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func populateData() {
        lblFeedback.text = feedbackTitle
        if let submit = formData?.btnSubmit {
            oltSubmit.setTitle(submit, for: .normal)
        }
        
        if let cancel = formData?.btnCancel {
            oltCancel.setTitle(cancel, for: .normal)
        }
        
        if let emailPH = formData?.email {
            txtEmail.placeholder = emailPH
        }
        if let title = formData?.title {
            txtSubject.placeholder = title
        }
        
        if let feedback = formData?.message {
            txtDescription.text = feedback
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == txtDescription {
            txtDescription.text = ""
        }
    }

    //MARK:- IBActions
    @IBAction func actionSubmit(_ sender: Any) {
        guard let email = txtEmail.text else {return}
        guard let subject = txtSubject.text else {return}
        guard let description = txtDescription.text else {return}
        
        if email == "" {
            txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if subject == "" {
            txtSubject.shake(6, withDelta: 10, speed: 0.06)
        }
        else if description == "" {
           
        }
        else {
            let param : [String: Any] = ["subject": subject, "email": email, "message": description]
            print(param)
            self.adForest_submit(param: param as NSDictionary)
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }
    
    //MARK:- API Call
    func adForest_submit(param: NSDictionary) {
        self.showLoader()
        UserHandler.feedback(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.dismissVC(completion: nil)
                })
                self.presentVC(alert)
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
    
}
