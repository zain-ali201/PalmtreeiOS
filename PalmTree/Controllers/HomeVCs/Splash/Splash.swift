//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Splash: UIViewController, NVActivityIndicatorViewable {
    
    
    //MARK:- Properties

    var isAppOpen = false
    var settingBlogArr = [String]()
    var isBlogImg:Bool = false
    var isSettingImg:Bool = false
    var imagesArr = [UIImage]()
    var isWplOn = false
    var isToplocationOn = false
    var isBlogOn = false
    var isSettingsOn = false
    var uploadingImage = ""
    var InValidUrl = ""

    //MARK:- Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingsdata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func checkLogin()
    {
        if defaults.bool(forKey: "isLogin") {
            guard let email = defaults.string(forKey: "email") else {
                return
            }
            guard let password = defaults.string(forKey: "password") else {
                return
            }
            if defaults.bool(forKey: "isSocial") {
                let param: [String: Any] = [
                    "email": email,
                    "type": "social"
                ]
                print(param)
                self.loginUser(parameters: param as NSDictionary)
            } else {
                let param : [String : Any] = [
                    "email" : email,
                    "password": password
                ]
                print(param)
                self.loginUser(parameters: param as NSDictionary)
            }
        }
        else
        {
            if isAppOpen
            {
                self.moveToHome()
            } else
            {
                self.appDelegate.moveToLogin()
            }
        }
    }
    
    //MARK:- API Call
    func settingsdata()
    {
        self.showLoader()
        UserHandler.settingsdata(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                defaults.set(successResponse.data.alertDialog.title, forKey: "aler")
                defaults.set(successResponse.data.internetDialog.okBtn, forKey: "okbtnNew")
                defaults.set(successResponse.data.internetDialog.cancelBtn, forKey: "cancelBtn")
                defaults.set(successResponse.data.alertDialog.select, forKey: "select")
                defaults.set(successResponse.data.alertDialog.camera, forKey: "camera")
                defaults.set(successResponse.data.alertDialog.CameraNotAvailable, forKey: "cameraNotAvavilable")
                defaults.set(successResponse.data.alertDialog.gallery, forKey: "gallery")

                defaults.set(successResponse.data.internetDialog.cancelBtn, forKey: "cancelbtnNew")
                defaults.set(successResponse.data.mainColor, forKey: "mainColor")
                self.appDelegate.customizeNavigationBar(barTintColor: Constants.hexStringToUIColor(hex: successResponse.data.mainColor))
                defaults.set(successResponse.data.isRtl, forKey: "isRtl")
                defaults.set(successResponse.data.gmapLang, forKey: "langCod")
                defaults.set(successResponse.data.notLoginMsg, forKey: "notLogin")
                defaults.set(successResponse.data.ImgReqMessage, forKey:"ImgReqMessage")
                defaults.set(successResponse.data.homescreenLayout, forKey:"homescreenLayout")
                defaults.set(successResponse.data.isAppOpen, forKey: "isAppOpen")
                defaults.set(successResponse.data.showNearby, forKey: "showNearBy")
                defaults.set(successResponse.data.showHome, forKey: "showHome")
                defaults.set(true, forKey: "showSearch")
                defaults.set(successResponse.data.advanceIcon, forKey: "advanceSearch")
                defaults.set(successResponse.data.buyText, forKey: "buy")
                defaults.set(successResponse.data.appPageTestUrl, forKey: "shopUrl")
                //Save Shop title to show in Shop Navigation Title
                defaults.set(successResponse.data.menu.shop, forKey: "shopTitle")
                self.isAppOpen = successResponse.data.isAppOpen
                self.isWplOn = successResponse.data.is_wpml_active
                self.isToplocationOn = successResponse.data.menu.isShowMenu.toplocation
                self.isBlogOn = successResponse.data.menu.isShowMenu.blog
                self.isSettingsOn = successResponse.data.menu.isShowMenu.settings
                defaults.set(self.isBlogOn, forKey: "isBlogOn")
                defaults.set(self.isSettingsOn, forKey: "isSettingsOn")

                defaults.set(self.isToplocationOn, forKey: "isToplocOn")
                defaults.set(self.isWplOn, forKey: "isWpOn")
                defaults.set(successResponse.data.wpml_menu_text, forKey: "meuText")
                self.uploadingImage = successResponse.data.ImgUplaoding
                defaults.set(self.uploadingImage, forKey: "Uploading")
                self.InValidUrl = successResponse.data.InValidUrl
                defaults.set(self.InValidUrl, forKey: "InValidUrl")

                //Offers title
                defaults.set(successResponse.data.messagesScreen.mainTitle, forKey: "message")
                defaults.set(successResponse.data.messagesScreen.sent, forKey: "sentOffers")
                defaults.set(successResponse.data.messagesScreen.receive, forKey: "receiveOffers")
                defaults.set(successResponse.data.messagesScreen.blocked, forKey: "blocked")
                defaults.synchronize()
                UserHandler.sharedInstance.objSettings = successResponse.data
                UserHandler.sharedInstance.objSettingsMenu = successResponse.data.menu.submenu.pages
               
                UserHandler.sharedInstance.menuKeysArray = successResponse.data.menu.dynamicMenu.keys
                
                if successResponse.data.menu.iStaticMenu != nil{
                    if successResponse.data.menu.iStaticMenu.keys != nil{
                        UserHandler.sharedInstance.otherKeysArray = successResponse.data.menu.iStaticMenu.keys
                    }
                }
            
                if successResponse.data.menu.iStaticMenu != nil{
                    if successResponse.data.menu.iStaticMenu.array != nil{
                        UserHandler.sharedInstance.otherValuesArray = successResponse.data.menu.iStaticMenu.array
                    }
                }
                
                defaults.set(successResponse.data.wpml_menu_text, forKey: "langHeading")
                
                if successResponse.data.menu.iStaticMenu.array == nil{
                    if  successResponse.data.menu.iStaticMenu.array == nil {
                        if self.isWplOn == true{
                            UserHandler.sharedInstance.otherKeysArray.append("wpml_menu_text")
                            UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.wpml_menu_text)
                        }
                    }
                    if successResponse.data.menu.isShowMenu.blog == true{
                        UserHandler.sharedInstance.otherKeysArray.append("blog")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.blog)
                    }
                    
                    if successResponse.data.menu.isShowMenu.settings == true{
                        UserHandler.sharedInstance.otherKeysArray.append("app_settings")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.appSettings)
                    }
                    if successResponse.data.menu.isShowMenu.toplocation == true{
//                        if successResponse.data.menu.topLocation != nil{
                        print(successResponse.data.menu.isShowMenu.toplocation)
                        UserHandler.sharedInstance.otherKeysArray.append("top_location_text")
                        UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.topLocation)
//                        }

                    }
                    
                    UserHandler.sharedInstance.otherKeysArray.append("logout")
                    UserHandler.sharedInstance.otherValuesArray.append(successResponse.data.menu.logout)
                    
                }
                
                if self.isWplOn == false {
                    if UserHandler.sharedInstance.menuKeysArray.contains("wpml_menu_text"){
                        
                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                    }
                }
                else{
                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                }
                
                
                //                if UserHandler.sharedInstance.menuKeysArray.contains("wpml_menu_text"){
                //                    UserHandler.sharedInstance.menuValuesArray = successResponse.data.menu.dynamicMenu.array
                //                }
                
                defaults.set(successResponse.data.location_text, forKey: "loc_text")
                //adding other section items in menu for leftViewController

                if successResponse.data.menu.isShowMenu.blog == true{
                    self.settingBlogArr.append(successResponse.data.menu.blog)
                    defaults.set(true, forKey: "isBlog")
                    self.imagesArr.append(UIImage(named: "blog")!)
                }
                if successResponse.data.menu.isShowMenu.settings == true{
                    defaults.set(true, forKey: "isSet")
                    self.imagesArr.append(UIImage(named: "settings")!)
                    self.settingBlogArr.append(successResponse.data.menu.appSettings)
                }

                if successResponse.data.menu.isShowMenu.toplocation == true{
                    print(successResponse.data.menu.isShowMenu.toplocation)
                    defaults.string(forKey: "is_top_location")
                    self.imagesArr.append(UIImage(named:"location")!)
                    self.settingBlogArr.append(successResponse.data.menu.topLocation)
                }
//                else{
//                    if UserHandler.sharedInstance.menuKeysArray.contains("top_location_text"){
//                    print("else ma ha ")
//                        self.showToast(message: "else ma ha ")
//                    }
//                }
                if self.isWplOn == true
                {
                    defaults.string(forKey: "is_wpml_active")
                    self.imagesArr.append(UIImage(named:"language")!)
                    self.settingBlogArr.append(successResponse.data.menu.wpml)
                }
                          
                defaults.set(self.settingBlogArr, forKey: "setArr")
                defaults.set(self.imagesArr, forKey: "setArrImg")
                print(self.imagesArr)
                
                let isLang = defaults.string(forKey: "langFirst")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                if self.isWplOn == true
                {
                    if isLang != "1"
                    {
                        let langCtrl = storyboard.instantiateViewController(withIdentifier: LangViewController.className) as! LangViewController
                        self.navigationController?.pushViewController(langCtrl, animated: true)
                    }
                    else
                    {
                        if successResponse.data.isRtl
                        {
                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//                            self.checkLogin()
                        }
                        else
                        {
                            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//                            self.checkLogin()
                        }
                        self.moveToHome()
                    }
                }
                else
                {
                    if successResponse.data.isRtl
                    {
                        UIView.appearance().semanticContentAttribute = .forceRightToLeft
//                        self.checkLogin()
                    }
                    else
                    {
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
//                        self.checkLogin()
                    }
                    self.moveToHome()
                }
                
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
    
    // Login User
    func loginUser(parameters: NSDictionary)
    {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                defaults.set(true, forKey: "isLogin")
                
                if defaults.string(forKey: "joining") == nil
                {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMM yyyy"
                    defaults.set(formatter.string(from: Date()), forKey: "joining")
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
                
                self.moveToHome()
            }
            else {
                self.appDelegate.moveToLogin()
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func moveToHome()
    {
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier: HomeController.className) as! HomeController
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

extension UserDefaults {
    func imageArray(forKey key: String) -> [UIImage]? {
        guard let array = self.array(forKey: key) as? [Data] else {
            return nil
        }
        return array.compactMap() { UIImage(data: $0) }
    }
    
    func set(_ imageArray: [UIImage], forKey key: String) {
        self.set(imageArray.compactMap({ UIImagePNGRepresentation($0) }), forKey: key)
    }
}
