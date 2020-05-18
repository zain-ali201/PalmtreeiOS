//
//  ShopController.swift
//  PalmTree
//
//  Created by SprintSols on 7/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import DropDown
import WebKit
class ShopController: UIViewController, UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate  {

    //MARK:- Outlets
    @IBOutlet weak var wkWebView: WKWebView!

    
    @IBOutlet weak var AdPostCircleButton: UIButton!{
        didSet{
            AdPostCircleButton.circularButtonShadow()
            if let bgColor = defaults.string(forKey: "mainColor") {
                AdPostCircleButton.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    //MARK:- Properties
    let cartButton = UIButton(type: .custom)
    let defaults = UserDefaults.standard
    var delegate :leftMenuProtocol?
    var titleArray = [String]()
    var urlArray = [String]()
    
    var shopDropDown = DropDown()
    lazy var dropDown: [DropDown] = {
        return [
            self.shopDropDown
        ]
    }()
    
    
    //MARK:- View Life Cycle
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        //        wkWebView == WKWebView(frame: .zero, configuration: webConfiguration)
        //        wkWebView.backgroundColor = UIColor.clear
        //        wkWebView.isOpaque = false
        //        wkWebView.navigationDelegate = self
        //        wkWebView.uiDelegate = self
        ////        view = wkWebView
        //        self.view.addSubview(wkWebView)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let shopTitle = defaults.string(forKey: "shopTitle") {
            self.title = shopTitle
        }
        self.populateShopData()
        self.addBackButtonToNavigationBar()
        self.googleAnalytics(controllerName: "ShopController")
        
        
        guard let userEmail = UserDefaults.standard.string(forKey: "email") else {return}
              guard let userPassword = UserDefaults.standard.string(forKey: "password") else {return}
              guard let shopUrl = defaults.string(forKey: "shopUrl") else {return}
              
              let emailPass = "\(userEmail):\(userPassword)"
              let encodedString = emailPass.data(using: String.Encoding.utf8)!
              let base64String = encodedString.base64EncodedString(options: [])
              print(base64String)
              
              let url = URL(string: shopUrl)
              
              if url != nil{
                  var request = URLRequest(url: url!)
                        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
                        request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
                        if UserDefaults.standard.bool(forKey: "isSocial") {
                            request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
                        }
                        self.wkWebView.load(request)
              }
            //navigationButtons()
        
        
    }
    //Adpost Btn Action/
    @IBAction func actionAdPost(_ sender: UIButton) {
        
        let notVerifyMsg = UserDefaults.standard.string(forKey: "not_Verified")
        let can = UserDefaults.standard.bool(forKey: "can")
        
        if can == false{
            var buttonOk = ""
            var buttonCancel = ""
            if let settingsInfo = defaults.object(forKey: "settings") {
                let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                let model = SettingsRoot(fromDictionary: settingObject)
                
                if let okTitle = model.data.internetDialog.okBtn {
                    buttonOk = okTitle
                }
                if let cancelTitle = model.data.internetDialog.cancelBtn {
                    buttonCancel = cancelTitle
                }
                
                let alertController = UIAlertController(title: "Alert", message: notVerifyMsg, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: buttonOk, style: .default) { (ok) in
                    self.appDelegate.moveToProfile()
                }
                let cancelBtn = UIAlertAction(title: buttonCancel, style: .cancel, handler: nil)
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                self.presentVC(alertController)
                
            }
        }else{
            let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
            self.navigationController?.pushViewController(adPostVC, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard let userEmail = UserDefaults.standard.string(forKey: "email") else {return}
//        guard let userPassword = UserDefaults.standard.string(forKey: "password") else {return}
//        guard let shopUrl = defaults.string(forKey: "shopUrl") else {return}
//
//        let emailPass = "\(userEmail):\(userPassword)"
//        let encodedString = emailPass.data(using: String.Encoding.utf8)!
//        let base64String = encodedString.base64EncodedString(options: [])
//        print(base64String)
//
//        let url = URL(string: shopUrl)
//
//        if url != nil{
//            var request = URLRequest(url: url!)
//                  request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
//                  request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
//                  if UserDefaults.standard.bool(forKey: "isSocial") {
//                      request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
//                  }
//                  self.webView.loadRequest(request)
//        }
//      navigationButtons()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked {
            var userEmail = ""
            var userPassword = ""
            if let email = defaults.string(forKey: "email") {
                userEmail = email
            }
            if let password = defaults.string(forKey: "password") {
                userPassword = password
            }
            let emailPass = "\(userEmail):\(userPassword)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            print(base64String)
            var urlRequest = request
            urlRequest.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
            if UserDefaults.standard.bool(forKey: "isSocial") {
                urlRequest.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
            }
//            self.webView.loadRequest(urlRequest)
            return true
        }
        return true
    }
    
    //MARK:- Custom
    
    var barButtonItems = [UIBarButtonItem]()
          func navigationButtons() {
                 //Location Search
                 let searchBarNavigation = UISearchBar()
                 
                 let searchButton = UIButton(type: .custom)
            if defaults.bool(forKey: "advanceSearch") == true{
                let con = UIImage(named: "controls")?.withRenderingMode(.alwaysTemplate)
                searchButton.setBackgroundImage(con, for: .normal)
                searchButton.tintColor = UIColor.white
                searchButton.setImage(con, for: .normal)
            }else{
                let con = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
                searchButton.setBackgroundImage(con, for: .normal)
                searchButton.tintColor = UIColor.white
                searchButton.setImage(con, for: .normal)
            }
                 if #available(iOS 11, *) {
                     searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
                     searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
                 } else {
                     searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                 }
                 searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
                 let searchItem = UIBarButtonItem(customView: searchButton)
                 if defaults.bool(forKey: "showNearBy") {
                     barButtonItems.append(searchItem)
              }
              self.barButtonItems.append(searchItem)
                 self.navigationItem.rightBarButtonItems = barButtonItems
       }
       
       @objc func actionSearch(){
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let proVc = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchController") as! AdvancedSearchController
           
           self.pushVC(proVc, completion: nil)
       }
    
    
    func addBackButtonToNavigationBar() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if UserDefaults.standard.bool(forKey: "isRtl") {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "arabicBackButton"), for: .normal)
        } else {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "backbutton"), for: .normal)
        }
        backButton.addTarget(self, action: #selector(moveToParentController), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func moveToParentController() {
        self.delegate?.changeViewController(.main)
    }
    
    
    func populateShopData() {
        if let userInfo = defaults.object(forKey: "settings") {
            let objUser = NSKeyedUnarchiver.unarchiveObject(with: userInfo as! Data) as! [String: Any]
            let userModel = SettingsRoot(fromDictionary: objUser)
            for items in userModel.data.shopMenu {
                if items.url == "" {
                    continue
                }
                self.titleArray.append(items.title)
                self.urlArray.append(items.url)
            }
        }
        self.dropDownData()
        self.ShopButton()
    }
    
    func ShopButton() {
        if #available(iOS 11, *) {
            cartButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            cartButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            cartButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        cartButton.addTarget(self, action: #selector(onClickShop), for: .touchUpInside)
        let cartImage = UIImage(named: "arrowDown")
        let tintImage = cartImage?.withRenderingMode(.alwaysTemplate)
        cartButton.setImage(tintImage , for: .normal)
        cartButton.tintColor = UIColor.white
        let barButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func onClickShop() {
       self.shopDropDown.show()
    }
    
    func dropDownData() {
        shopDropDown.anchorView = cartButton
        shopDropDown.dataSource = titleArray
        shopDropDown.selectionAction = { [unowned self] (index, item) in
            self.cartButton.setTitle(item, for: .normal)
            let selectedURL = self.urlArray[index]
            guard let userEmail = UserDefaults.standard.string(forKey: "email") else {return}
            guard let userPassword = UserDefaults.standard.string(forKey: "password") else {return}

            let emailPass = "\(userEmail):\(userPassword)"
            let encodedString = emailPass.data(using: String.Encoding.utf8)!
            let base64String = encodedString.base64EncodedString(options: [])
            print(base64String)
            let url = URL(string: selectedURL)
            var request = URLRequest(url: url!)
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            request.setValue("body", forHTTPHeaderField: "Adforest-Shop-Request")
            if UserDefaults.standard.bool(forKey: "isSocial") {
                request.setValue("social", forHTTPHeaderField: "AdForest-Login-Type")
            }
//            self.webView.loadRequest(request)
        }
    }
}
