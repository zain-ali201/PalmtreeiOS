//
//  ReplyCommentController.swift
//  PalmTree
//
//  Created by SprintSols on 3/16/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import TextFieldEffects
import UITextField_Shake

protocol moveTomessagesDelegate {
    func isMoveMessages(isMove: Bool)
}

class ReplyCommentController: UIViewController , NVActivityIndicatorViewable{

    //MARK:- Outlets
    
    @IBOutlet weak var viewMsg: UIView! {
        didSet {
            viewMsg.circularView()
        }
    }
    @IBOutlet weak var imgMessage: UIButton!
    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var containerViewCall: UIView!
    @IBOutlet weak var containerViewTxtField: UIView!
    @IBOutlet weak var txtComment: HoshiTextField!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonOK: UIButton!
    
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var lblNumber: UILabel! {
        didSet {
            lblNumber.layer.borderWidth = 1
            lblNumber.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var lblVerificationText: UILabel!
    
    //MARK:- Properties
    var delegate: moveTomessagesDelegate?
    var isFromReplyComment = false
    var isFromMsg = false
    var isFromCall = false
    var isFromAddDetailReply = false
    var isFromUserRating = false
    var objAddDetail: AddDetailReplyDialogue?
    var objAddDetailData: AddDetailData?
    var objBlog : BlogDetailRoot?
    let defaults = UserDefaults.standard
    var ad_id = 0
    var comment_id = ""
    var phoneNumber = ""
    
    var post_id = 0
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Reply Comment Controller")
        self.checkComingSide()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            buttonCancel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            buttonOK.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtComment.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtComment.textAlignment = .right
            
        }
    }

    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func checkComingSide()
    {
        if isFromReplyComment {
//            containerViewCall.isHidden = true
            containerViewTxtField.isHidden = false
            if objBlog != nil {
                let objData = objBlog
                if let postID = objData?.data.post.postId {
                    self.post_id = postID
                }
                if let commentButtonText = objData?.extra.commentForm.btnSubmit {
                    self.buttonOK.setTitle(commentButtonText, for: .normal)
                }
                if let cancelButtonText = objData?.extra.commentForm.btnCancel {
                    self.buttonCancel.setTitle(cancelButtonText, for: .normal)
                }
                if let txtPlaceHolder = objData?.extra.commentForm.textarea {
                    self.txtComment.placeholder = txtPlaceHolder
                }
            }
        }
        else if isFromMsg
        {
            if objAddDetailData != nil {
                let dataToShow = objAddDetailData
                
//                containerViewCall.isHidden = true
                containerViewTxtField.isHidden = false
                
//                if let adId = dataToShow?.adDetail.adId {
//                    self.ad_id = adId
//                }
                
                if let placeHoderText =  dataToShow?.messagePopup.inputTextarea {
                    txtComment.placeholder = placeHoderText
                }
                if let sendButtonText = dataToShow?.messagePopup.btnSend {
                    buttonOK.setTitle(sendButtonText, for: .normal)
                }
                if let cancelText = dataToShow?.messagePopup.btnCancel {
                    buttonCancel.setTitle(cancelText, for: .normal)
                }
            }
        }
        else if isFromCall
        {
            if objAddDetailData != nil {
                let dataToShow = objAddDetailData
                containerViewTxtField.isHidden = true
//                containerViewCall.isHidden = false
                self.imgPic.image = UIImage(named: "Phone")
                if let buttonOkText = dataToShow?.callNowPopup.btnSend {
                    self.buttonOK.setTitle(buttonOkText, for: .normal)
                }
                if let buttonCancelText = dataToShow?.callNowPopup.btnCancel {
                    self.buttonCancel.setTitle(buttonCancelText, for: .normal)
                }
                if let number = dataToShow?.adDetail.phone {
                    self.lblNumber.text = number
                    self.phoneNumber = number
                }
                if let text = dataToShow?.callNowPopup.isPhoneVerifiedText {
                    self.lblVerificationText.text = text
                }
                //Local Variable
                var isPhoneVerification = false
                var isPhoneVerified = false
                if let isVerification = dataToShow?.callNowPopup.phoneVerification {
                    isPhoneVerification = isVerification
                }
                if isPhoneVerification {
                    if let isPhone = dataToShow?.callNowPopup.isPhoneVerified{
                        isPhoneVerified = isPhone
                    }
                    if isPhoneVerified {
                        self.lblVerificationText.backgroundColor = Constants.hexStringToUIColor(hex: "#24a740")
                    }
                    else {
                        self.lblVerificationText.backgroundColor = Constants.hexStringToUIColor(hex: "#F25E5E")
                    }
                }
            }
        } else if isFromAddDetailReply {
//            containerViewCall.isHidden = true
            containerViewTxtField.isHidden = false
            if objAddDetail != nil {
                let dataToShow = objAddDetail
                if let txtPlaceHolder = dataToShow?.text {
                    self.txtComment.placeholder = txtPlaceHolder
                }
                if let submitText = dataToShow?.sendBtn {
                    self.buttonOK.setTitle(submitText, for: .normal)
                }
                if let cancelText = dataToShow?.cancelBtn {
                    self.buttonCancel.setTitle(cancelText, for: .normal)
                }
            } else {
                print("No Data")
            }
        } else if isFromUserRating {
//            containerViewCall.isHidden = true
            containerViewTxtField.isHidden = false
            if AddsHandler.sharedInstance.userRatingForm != nil {
                let objData = AddsHandler.sharedInstance.userRatingForm
                if let placeHolder = objData?.textareaText {
                    txtComment.placeholder = placeHolder
                }
                if let settingsInfo = defaults.object(forKey: "settings") {
                    let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: settingObject)
                    
                    if let okTitle = model.data.internetDialog.okBtn {
                        buttonOK.setTitle(okTitle, for: .normal)
                    }
                    if let cancelTitle = model.data.internetDialog.cancelBtn {
                        buttonCancel.setTitle(cancelTitle, for: .normal)
                    }
                }
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionBigButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }
    
    @IBAction func actionOK(_ sender: UIButton) {
        guard let commentField = txtComment.text else {
            return
        }
        if isFromMsg {
            if commentField == "" {
                self.txtComment.shake(6, withDelta: 10, speed: 0.06)
            }
            else  {
                let param: [String: Any] = ["ad_id": ad_id, "message": commentField]
                print(param)
                self.popUpMessageReply(param: param as NSDictionary)
            }
        }
        else if isFromAddDetailReply {
            if commentField == "" {
                self.txtComment.shake(6, withDelta: 10, speed: 0.06)
            }
            else {
                let param: [String: Any] = ["ad_id": ad_id, "comment_id": comment_id, "rating_comments": commentField]
                print(param)
                self.replyComment(param: param as NSDictionary)
            }
        }
        else if isFromCall {
            phoneNumber.makeAColl()
        }
        else if isFromReplyComment {
            if commentField == "" {
                self.txtComment.shake(6, withDelta: 10, speed: 0.06)
            }
            else {
                let param: [String: Any] = ["comment_id": comment_id, "post_id": post_id, "message": commentField]
                print(param)
                self.blogPostComment(param: param as NSDictionary)
            }
        } else if isFromUserRating {
            if commentField == "" {
                self.txtComment.shake(6, withDelta: 10, speed: 0.06)
            } else {
                let param: [String: Any]  =  ["author_id": self.comment_id,"comments": commentField, "is_reply": true]
                print(param)
                self.rating(param: param as NSDictionary)
            }
        }
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }
    
    //MARK:- API Call
    //comment
    func replyComment(param: NSDictionary) {
        self.showLoader()
        AddsHandler.replyComment(parameters: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.updateAddDetails), object: nil)
                    self.dismiss(animated: true, completion: nil)
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
    
    // pop up message reply
    func popUpMessageReply(param: NSDictionary) {
        self.showLoader()
        AddsHandler.popMsgReply(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.dismissVC(completion: {
                        self.delegate?.isMoveMessages(isMove: true)
                    })
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
    
    // blog post comment
    func blogPostComment(param: NSDictionary) {
        self.showLoader()
        UserHandler.blogPostComment(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
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
    
    
    func rating(param: NSDictionary) {
        self.showLoader()
        AddsHandler.postUserRating(param: param, success: { (successResponse) in
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
