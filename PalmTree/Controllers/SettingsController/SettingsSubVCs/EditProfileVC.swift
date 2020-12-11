//
//  TermsConditionsController.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class EditProfileVC: UIViewController, NVActivityIndicatorViewable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var editBtn1: UIButton!
    @IBOutlet weak var editBtn2: UIButton!
    
    var passwordToSave = ""
    
    var profileImage:UIImage = UIImage(named: "avatar")!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileBtn.layer.cornerRadius = 50
        profileBtn.layer.masksToBounds = true
        
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

        if userDetail?.avatar != nil
        {
            profileBtn.setImage(userDetail?.avatar, for: .normal)
        }
        else
        {
            if userDetail?.profileImg != nil && userDetail?.profileImg != ""
            {
                Alamofire.request(String(format: "%@%@", Constants.URL.imagesUrl, userDetail?.profileImg ?? "")).responseImage { response in
                    debugPrint(response)

                    if case .success(let image) = response.result {
                        userDetail?.avatar = image
                        self.profileBtn.setBackgroundImage(image, for: .normal)
                    }
                }
            }
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
    
    @IBAction func profileBtnAction(_ sender: Any)
    {
        let select = languageCode == "ar" ? "إختر" : "Select"
        
        let actionSheet = UIAlertController(title: select, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = languageCode == "ar" ? "الكاميرا" : "Camera"
        actionSheet.addAction(UIAlertAction(title: camera, style: .default, handler: { (action) -> Void in
            
            let imagePickerConroller = UIImagePickerController()
            imagePickerConroller.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerConroller.sourceType = .camera
            }
            else
            {
                let al = UserDefaults.standard.string(forKey: "aler")
                 let ok = UserDefaults.standard.string(forKey: "okbtnNew")
                let alert = UIAlertController(title: al, message: "cameraNotAvailable", preferredStyle: UIAlertControllerStyle.alert)
                let OkAction = UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(OkAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.present(imagePickerConroller,animated:true, completion:nil)
        }))
        
        let gallery = languageCode == "ar" ? "الإستديو" : "Photo Gallery"
        actionSheet.addAction(UIAlertAction(title: gallery, style: .default, handler: { (action) -> Void in

            let imagePickerConroller = UIImagePickerController()
            imagePickerConroller.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerConroller.sourceType = .photoLibrary
            }
            self.present(imagePickerConroller,animated:true, completion:nil)

        }))
        let cancel = languageCode == "ar" ? "إلغاء" : "Cancel"
            actionSheet.addAction(UIAlertAction(title: cancel, style: .destructive, handler: { (action) -> Void in
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
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
                "current_password": oldPassword,
                "new_pass": newPassword,
                "email": userDetail?.userEmail ?? ""
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
            let parameters: [String: Any] = [
                "name": name,
                "phone": phone,
                "user_id": userDetail?.id ?? 0
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
            if successResponse.success
            {
                let alert = AlertView.prepare(title: "Palmtree", message: successResponse.message, okAction: {
                    self.contactView.alpha = 0
                    userDetail?.displayName = self.txtFirstName.text!
                    userDetail?.phone = self.txtNumber.text!
                    
                    defaults.set(userDetail?.displayName, forKey: "displayName")
                    defaults.set(userDetail?.phone, forKey: "phone")
                    
                    self.lblName.text = userDetail?.displayName ?? ""
                    self.lblDisplayName.text = userDetail?.displayName ?? ""
                    self.lblNumber.text = userDetail?.phone ?? ""
                    self.btnAddPhone.alpha = 0
                    self.lblNumber.alpha = 1
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil
        {
            if var pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                pickedImage = resizeImage(image: pickedImage, targetSize: CGSize(width: 300, height: 300))
                profileImage = pickedImage
                profileBtn.setBackgroundImage(pickedImage, for: .normal)
            }
            
            dismiss(animated: true, completion: {
                let message = languageCode == "ar" ? "هل تريد تحديث ملفك الشخصي؟" : "Do you want to update your profile picture?"
                
                let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let camera = languageCode == "ar" ? "نعم" : "YES"
                alert.addAction(UIAlertAction(title: camera, style: .default, handler: { [self] (action) -> Void in
                    self.updateProfilePic()
                }))
                
                let cancel = languageCode == "ar" ? "لا" : "NO"
                alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { (action) -> Void in
                }))
                
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    func updateProfilePic()
    {
        self.showLoader()
        let parameters : [String: Any] = ["id": String(format: "%d", userDetail?.id ?? 0)]
        
        adPostUploadSingleImage(parameter: parameters as NSDictionary, image: profileImage, fileName: "image", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            
            self.stopAnimating()
            if successResponse.success
            {
                userDetail?.avatar = self.profileImage
                userDetail?.profileImg = successResponse.data.url.encodeUrl()
                defaults.set(userDetail?.profileImg, forKey: "url")
                self.showToast(message: "Profile picture updated successfully.")
            }
            else
            {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adPostUploadSingleImage(parameter: NSDictionary, image: UIImage, fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(ImageRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.userImageUpdate
        print(url)
        NetworkHandler.uploadSingleImage(url: url, image: image, fileName: "image", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            
        }, success: { (successResponse) in
            
            let dictionary = successResponse as! [String: Any]
            print(dictionary)
            let objImg = ImageRoot(fromDictionary: dictionary)
            success(objImg)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
            self.stopAnimating()
        }
    }
}
