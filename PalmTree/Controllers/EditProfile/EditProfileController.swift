//
//  EditProfileController.swift
//  PalmTree
//
//  Created by SprintSols on 3/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import TextFieldEffects
import DropDown
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import NVActivityIndicatorView
import JGProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import IQKeyboardManagerSwift


class EditProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            let nib = UINib(nibName: "ProfileCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "ProfileCell")
            let nibStatus = UINib(nibName: "AddsStatusCell", bundle: nil)
            tableView.register(nibStatus, forCellReuseIdentifier: "AddsStatusCell")
        }
    }
    
    @IBOutlet weak var oltAdPost: UIButton! {
        didSet {
            oltAdPost.circularButton()
            if let bgColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltAdPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    
    //MARK:- Properties
    
    var userAddress = ""
    var accountTypeArray = [String]()
    var dataArray = [ProfileDetailsData]()
    var socialArray = [ProfileDetailsAccountType]()

    let defaults = UserDefaults.standard
    
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
    var facebook = ""
    var linkedin = ""
    var twitter = ""
    var google = ""

    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = UserHandler.sharedInstance.objProfileDetails?.extraText.profileEditTitle
        self.showBackButton()
        self.googleAnalytics(controllerName: "Edit Profile Controller")
        self.hideKeyboard()
        self.profileDetails()
        
        self.adMob()
        if defaults.bool(forKey: "isGuest") {
            self.oltAdPost.isHidden = true
        }
        navigationButtons()
    }
    
    //MARK:- Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adMob() {
        if UserHandler.sharedInstance.objAdMob != nil {
            let objData = UserHandler.sharedInstance.objAdMob
            
            var isShowAd = false
            if let adShow = objData?.show {
                isShowAd = adShow
            }
            if isShowAd {
                var isShowBanner = false
                var isShowInterstital = false
                
                if let banner = objData?.isShowBanner {
                    isShowBanner = banner
                }
                if let intersitial = objData?.isShowInitial {
                    isShowInterstital = intersitial
                }
                
                if isShowBanner {
                    SwiftyAd.shared.setup(withBannerID: (objData?.bannerId)!, interstitialID: "", rewardedVideoID: "")
                    self.tableView.translatesAutoresizingMaskIntoConstraints = false
                    if objData?.position == "top" {
                        SwiftyAd.shared.showBanner(from: self, at: .top)
                        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
                    }
                    else {
                        SwiftyAd.shared.showBanner(from: self, at: .bottom)
                        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
                    }
                }
                if isShowInterstital {
//                    SwiftyAd.shared.setup(withBannerID: "", interstitialID: (objData?.interstitalId)!, rewardedVideoID: "")
//                    SwiftyAd.shared.showInterstitial(from: self)
                    
                    self.perform(#selector(self.showAd), with: nil, afterDelay: Double(objData!.timeInitial)!)
                    self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(objData!.time)!)
                    
                }
            }
        }
    }
    
    @objc func showAd(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    @objc func showAd2(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
         let objData = dataArray[indexPath.row]
        if section == 0 {
            let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            
           // let objData = dataArray[indexPath.row]
            cell.containerViewEditProfile.isHidden = true
            
            if let imgUrl = URL(string: objData.profileExtra.profileImg) {
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
            }
            if let userName = objData.profileExtra.displayName {
                cell.lblName.text = userName
            }
            if let lastLogin = objData.profileExtra.lastLogin {
                cell.lblLastlogin.text = lastLogin
            }
            if let avgRating = objData.profileExtra.rateBar.text {
                cell.lblAvgRating.text = avgRating
            }
            if let isUserVerified = objData.profileExtra.verifyButon.text {
                cell.lblStatus.text = isUserVerified
                cell.lblStatus.backgroundColor = Constants.hexStringToUIColor(hex: objData.profileExtra.verifyButon.color)
            }
            if let ratingBar = objData.profileExtra.rateBar.number {
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.settings.fillMode = .precise
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: "#ffcc00")
                cell.ratingBar.rating = Double(ratingBar)!
            }
            for obj in socialArray {
                if obj.fieldName == "_sb_profile_facebook" {
                    self.facebook = obj.fieldName
                    UserDefaults.standard.set(facebook, forKey: "facebook")
                }
                if obj.fieldName == "_sb_profile_twitter" {
                    self.twitter = obj.fieldName
                    UserDefaults.standard.set(twitter, forKey: "twitter")

                }
                if obj.fieldName == "_sb_profile_linkedin" {
                    self.linkedin = obj.fieldName
                    UserDefaults.standard.set(linkedin, forKey: "linkedin")
                }
                if obj.fieldName == "_sb_profile_google-plus" {
                    self.google = obj.fieldName
                    UserDefaults.standard.set(google, forKey: "google")
                }
            }
            
            return cell
        }
            
        else if section == 1 {
            let cell: AddsStatusCell = tableView.dequeueReusableCell(withIdentifier: "AddsStatusCell", for: indexPath) as! AddsStatusCell
           // let objData = dataArray[indexPath.row]
            
            if let soldAds = objData.profileExtra.adsSold {
                cell.lblSoldAds.text = soldAds
            }
            if let allAds = objData.profileExtra.adsTotal {
                cell.lblAllAds.text = allAds
            }
            if let inactiveAds = objData.profileExtra.adsInactive {
                cell.lblInactiveAds.text = inactiveAds
            }
            if let expAds = objData.profileExtra.adsExpired {
                cell.lblExpireAds.text = expAds
            }
            return cell
        }
        else if section == 2 {
            
            let cell : EditProfileCell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell", for: indexPath) as! EditProfileCell
           
            let extraData = UserHandler.sharedInstance.objProfileDetails
            
            if row == 0 {
                if let title = extraData?.extraText.profileEditTitle {
                    cell.lblEditProfile.text = title
                }
                if let changePasswordTitle = extraData?.extraText.changePass.title {
                    cell.buttonChangePassword.setTitle(changePasswordTitle, for: .normal)
                }
                cell.btnChangePassword = { () in
                    let passVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
                    passVC.modalPresentationStyle = .overCurrentContext
                    passVC.modalTransitionStyle = .crossDissolve
                    passVC.dataToShow = extraData
                    self.presentVC(passVC)
                }
                
                if let nameText = objData.displayName.key {
                    cell.lblName.text = nameText
                }
                
                if let nameValue = objData.displayName.value {
                    cell.txtName.text = nameValue
                }
                if let phoneText = objData.phone.key {
                    cell.lblPhone.text = phoneText
                }
                if let phoneValue = objData.phone.value {
                    cell.txtPhone.text = phoneValue
                }
                if let accountTypeText = objData.accountType.key {
                    cell.lblAccountType.text = accountTypeText
                }
                if let dropDownButtontext = objData.accountType.value {
                    cell.buttonAccountType.setTitle(dropDownButtontext, for: .normal)
                    cell.accountType = dropDownButtontext
                }
                
                cell.btnDropDown = { () in
                    cell.dropDownDataArray = []
                    for items in objData.accountTypeSelect {
                        cell.dropDownDataArray.append(items.value)
                    }
                    cell.accountDropDown()
                    cell.accountTypeDropDown.show()
                }
                
                if let locationText = objData.location.key {
                    cell.lblAddress.text = locationText
                }
                if let locationValue = objData.location.value {
                    cell.textAddress.text = locationValue
                    
                }
                for obj in socialArray {
                    if obj.fieldName == "_sb_profile_facebook" {
                        cell.txtFacebook.text = obj.value
                    }
                    if obj.fieldName == "_sb_profile_twitter" {
                        cell.txtTwitter.text = obj.value
                    }
                    if obj.fieldName == "_sb_profile_linkedin" {
                        cell.txtLinkedIn.text = obj.value
                    }
                    if obj.fieldName == "_sb_profile_google-plus" {
                        cell.txtGooglePlus.text = obj.value
                    }
                }
                if let imgText = objData.profileImg.key {
                    cell.lblImage.text = imgText
                }
                if let imgUrl = URL(string: objData.profileImg.value) {
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                }
                if let introductionText = objData.introduction.key {
                    cell.lblIntroduction.text = introductionText
                }
                if let introductionValue = objData.introduction.value {
                    cell.txtIntroduction.text = introductionValue
                }
                if let updateTitle = extraData?.extraText.saveBtn {
                    cell.buttonUpdate.setTitle(updateTitle, for: .normal)
                }
                
                if let title = extraData?.extraText.selectPic.title {
                    cell.titleAddPhotos = title
                }
                if let cameratext = extraData?.extraText.selectPic.camera {
                    cell.titleCamera = cameratext
                }
                if let galleryText = extraData?.extraText.selectPic.library {
                    cell.titleGallery = galleryText
                }
                if let cancelText = extraData?.extraText.selectPic.cancel {
                    cell.titleCancel = cancelText
                }
                if let cameraNotText = extraData?.extraText.selectPic.noCamera {
                    cell.titleCameraNotAvailable = cameraNotText
                }
                
                var canDeleteAccount = false
                var isDelFb = false
                
                if let canDelete = extraData?.data.canDeleteAccount {
                    canDeleteAccount = canDelete
                }
                
                if canDeleteAccount {
                    cell.buttonDelete.isHidden = false
                    if let deleteButtonText = extraData?.data.deleteAccount.text {
                        cell.buttonDelete.setTitle(deleteButtonText, for: .normal)
                    }
                    cell.btnDelete = { () in
                        var message = ""
                        var btnCancel = ""
                        var btnConfirm = ""
                        if let popUpText = extraData?.data.deleteAccount.popuptext {
                            message = popUpText
                        }
                        if let confirmText = extraData?.data.deleteAccount.btnSubmit {
                            btnConfirm = confirmText
                        }
                        if let cancelText = extraData?.data.deleteAccount.btnCancel {
                            btnCancel = cancelText
                        }
                        var id = 0
                        if let userID = extraData?.data.id {
                            id = userID
                        }
                        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: btnConfirm, style: .default) { (action) in
                            let param: [String: Any] = ["user_id": id]
                            print(param)
                            self.deleteAccount(param: param as NSDictionary)
                        }
                        let cancelAction = UIAlertAction(title: btnCancel, style: .default, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(confirmAction)
                        self.presentVC(alert)
                    }
                }
                else {
                    cell.buttonDelete.isHidden = true
                }
            }
                return cell
            }
                return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat = 0
        if section == 0 {
            height = 105
        }
        else if section == 1 {
            height = 65
        }
        else if section == 2 {
            height = 810
        }
       
        return height
    }
    
    //MARK:- IBActions
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
    
    
    
    //MARK:- API Call
    
    // Profile Details
    
    func profileDetails() {
        self.showLoader()
        UserHandler.profileGet(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray = [successResponse.data]
                self.socialArray = successResponse.data.profileExtra.socialIcons
                UserHandler.sharedInstance.objProfileDetails = successResponse
                self.tableView.reloadData()
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
    
    //Delete Account
    func deleteAccount(param: NSDictionary) {
        self.showLoader()
        UserHandler.deleteAccount(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.defaults.set(false, forKey: "isLogin")
                    self.defaults.set(false, forKey: "isGuest")
                    self.defaults.set(false, forKey: "isSocial")
                    let loginManager = LoginManager()
                    loginManager.logOut()
                    self.appDelegate.moveToLogin()
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
    

    //MARK:- Near by search Delaget method
      func nearbySearchParams(lat: Double, long: Double, searchDistance: CGFloat, isSearch: Bool) {
          self.latitude = lat
          self.longitude = long
          self.searchDistance = searchDistance
          if isSearch {
              let param: [String: Any] = ["nearby_latitude": lat, "nearby_longitude": long, "nearby_distance": searchDistance]
              print(param)
              self.nearBySearch(param: param as NSDictionary)
          } else {
              let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
              print(param)
              self.nearBySearch(param: param as NSDictionary)
          }
      }
      
      
      func navigationButtons() {
          
          //Home Button
          let HomeButton = UIButton(type: .custom)
          let ho = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
          HomeButton.setBackgroundImage(ho, for: .normal)
          HomeButton.tintColor = UIColor.white
          HomeButton.setImage(ho, for: .normal)
          if #available(iOS 11, *) {
              searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
              searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
          } else {
              HomeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
          }
          HomeButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
          let homeItem = UIBarButtonItem(customView: HomeButton)
          if defaults.bool(forKey: "showHome") {
              barButtonItems.append(homeItem)
              //self.barButtonItems.append(homeItem)
          }
        
          //Location Search
          let locationButton = UIButton(type: .custom)
          if #available(iOS 11, *) {
              locationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
              locationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
          }
          else {
              locationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
          }
          let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
          locationButton.setBackgroundImage(image, for: .normal)
          locationButton.tintColor = UIColor.white
          locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
          let barButtonLocation = UIBarButtonItem(customView: locationButton)
          if defaults.bool(forKey: "showNearBy") {
              self.barButtonItems.append(barButtonLocation)
          }
          //Search Button
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
          if defaults.bool(forKey: "showSearch") {
              barButtonItems.append(searchItem)
              //self.barButtonItems.append(searchItem)
          }
      
          self.navigationItem.rightBarButtonItems = barButtonItems
         
      }
      
      @objc func actionHome() {
          appDelegate.moveToHome()
      }

      @objc func onClicklocationButton() {
          let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearch
          locationVC.delegate = self
          view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
          UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
              self.view.transform = .identity
          }) { (success) in
              self.navigationController?.pushViewController(locationVC, animated: true)
          }
      }
      
     
      //MARK:- Search Controller
      
      @objc func actionSearch(_ sender: Any) {
      
          if defaults.bool(forKey: "advanceSearch") == true{
              let storyBoard = UIStoryboard(name: "Main", bundle: nil)
              let proVc = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchController") as! AdvancedSearchController
              self.pushVC(proVc, completion: nil)
          }else{
              
              //setupNavigationBar(title: "okk...")
              
              keyboardManager.enable = true
              if isNavSearchBarShowing {
                  navigationItem.titleView = nil
                  self.searchBarNavigation.text = ""
                  self.backgroundView.removeFromSuperview()
                  self.addTitleView()

              } else {
                  self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                  self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                  self.backgroundView.isOpaque = true
                  let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                  tap.delegate = self
                  self.backgroundView.addGestureRecognizer(tap)
                  self.backgroundView.isUserInteractionEnabled = true
                  self.view.addSubview(self.backgroundView)
                  self.adNavSearchBar()
              }
          }
          
      }
      
      @objc func handleTap(_ gestureRocognizer: UITapGestureRecognizer) {
          self.actionSearch("")
      }
      
      func adNavSearchBar() {
          searchBarNavigation.placeholder = "Search Ads"
          searchBarNavigation.barStyle = .default
          searchBarNavigation.isTranslucent = false
          searchBarNavigation.barTintColor = UIColor.groupTableViewBackground
          searchBarNavigation.backgroundImage = UIImage()
          searchBarNavigation.sizeToFit()
          searchBarNavigation.delegate = self
          self.isNavSearchBarShowing = true
          searchBarNavigation.isHidden = false
          navigationItem.titleView = searchBarNavigation
          searchBarNavigation.becomeFirstResponder()
      }
      
      func addTitleView() {
          self.searchBarNavigation.endEditing(true)
          self.isNavSearchBarShowing = false
          self.searchBarNavigation.isHidden = true
          self.view.isUserInteractionEnabled = true
      }
      
      //MARK:- Search Bar Delegates
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          
      }
      
      func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
          //self.searchBarNavigation.endEditing(true)
          searchBar.endEditing(true)
          self.view.endEditing(true)
      }
      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchBar.endEditing(true)
          self.searchBarNavigation.endEditing(true)
          guard let searchText = searchBar.text else {return}
          if searchText == "" {
              
          } else {
              let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
              categoryVC.searchText = searchText
              categoryVC.isFromTextSearch = true
              self.navigationController?.pushViewController(categoryVC, animated: true)
          }
      }
      
    
    
    //MARK:- Near By Search
       func nearBySearch(param: NSDictionary) {
           self.showLoader()
           AddsHandler.nearbyAddsSearch(params: param, success: { (successResponse) in
               self.stopAnimating()
               if successResponse.success {
                   let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                   categoryVC.latitude = self.latitude
                   categoryVC.longitude = self.longitude
                   categoryVC.nearByDistance = self.searchDistance
                   categoryVC.isFromNearBySearch = true
                   self.navigationController?.pushViewController(categoryVC, animated: true)
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


class EditProfileCell: UITableViewCell, UITextFieldDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {

    
    private lazy var uploadingProgressBar: JGProgressHUD = {
        let progressBar = JGProgressHUD(style: .dark)
        progressBar.indicatorView = JGProgressHUDRingIndicatorView()
        let ImgUplaoding = UserDefaults.standard.string(forKey: "Uploading")
        progressBar.textLabel.text = ImgUplaoding
        return progressBar
    }()
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblEditProfile: UILabel!
    @IBOutlet weak var buttonChangePassword: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                buttonChangePassword.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var buttonAccountType: UIButton! {
        didSet {
            buttonAccountType.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var textAddress: UITextView! {
        didSet {
            textAddress.delegate = self
            textAddress.layer.borderWidth = 0.5
            textAddress.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
  
    @IBOutlet weak var lblImage: UILabel!
    @IBOutlet weak var imgPicture: UIImageView! {
        didSet {
            let tapImage = UITapGestureRecognizer(target: self, action: #selector(imageGet))
            imgPicture.addGestureRecognizer(tapImage)
            imgPicture.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var lblIntroduction: UILabel!
    @IBOutlet weak var txtIntroduction: UITextView! {
        didSet {
            txtIntroduction.layer.borderWidth = 0.5
            txtIntroduction.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var txtFacebook: HoshiTextField!
    @IBOutlet weak var txtTwitter: HoshiTextField!
    @IBOutlet weak var txtLinkedIn: HoshiTextField!
    @IBOutlet weak var txtGooglePlus: HoshiTextField!
    @IBOutlet weak var buttonUpdate: UIButton!
    @IBOutlet weak var buttonDelete: UIButton! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor"){
                buttonDelete.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    
    //MARK:- Properties
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var imagePicker = UIImagePickerController()
    var defaults = UserDefaults.standard
   
    var imageUrl : URL!
    var imageSelect: UIImage!
    let fileName = "profile_img"
    
    var titleAddPhotos = ""
    var titleCamera = ""
    var titleGallery = ""
    var titleCancel = ""
    var titleCameraNotAvailable = ""
    
    var accountType = ""
    
    let accountTypeDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.accountTypeDropDown
        ]
    }()
    
    var btnDropDown : (()->())?
    var btnChangePassword: (()->())?
    var btnUpdate: (()->())?
    var dropDownDataArray = [String]()
    var btnDelete: (()->())?
    
    //MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        txtFacebook.font = UIFont.systemFont(ofSize: 20.0)
        txtTwitter.font = UIFont.systemFont(ofSize: 20.0)
        txtLinkedIn.font = UIFont.systemFont(ofSize: 20.0)
        txtGooglePlus.font = UIFont.systemFont(ofSize: 20.0)

        print(UIFont.familyNames)

    }

    //MARK:- Custom
    
    @objc func imageGet() {
        let alert = UIAlertController(title: titleAddPhotos, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: titleCamera, style: .default) { (actionIn) in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: titleGallery, style: .default) { (actionIn) in
            self.openGallery()
        }
        let SettingsAction = UIAlertAction(title: "Settings", style: .default) { (actionIn) in
//            self.openSettings()
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                           return
                       }
                       if UIApplication.shared.canOpenURL(settingsUrl) {
                           UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                        }
        }
        
        let cancelAction = UIAlertAction(title: titleCancel, style: .default) { (actionIn) in
            self.cancel()
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(SettingsAction)
        alert.addAction(cancelAction)
        self.appDel.presentController(ShowVC: alert)
    }
     func openSettings(){
        // initialise a pop up for using later
        let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
             }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)

        // check the permission status
        switch(CLLocationManager.authorizationStatus()) {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                // get the user location
            case .notDetermined, .restricted, .denied:
                // redirect the users to settings
//                self.present(alertController, animated: true, completion: nil)
            self.appDel.presentController(ShowVC: alertController)

        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            self.appDel.presentController(ShowVC: imagePicker)
        }
        else {
            let alert = Constants.showBasicAlert(message: titleCameraNotAvailable)
            self.appDel.presentController(ShowVC: alert)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.appDel.presentController(ShowVC: imagePicker)
        }
        else {
            
        }
    }
    
    func cancel() {
        self.appDel.dissmissController()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgPicture.image = pickedImage
            imageSelect = pickedImage
            saveFileToDocumentDirectory(image: imageSelect)
            self.uploadImage()
        }
        self.appDel.dissmissController()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.appDel.dissmissController()
    }
    
    func saveFileToDocumentDirectory(image: UIImage) {
        if let savedUrl = FileManager.default.saveFileToDocumentsDirectory(image: image, name: self.fileName, extention: ".png") {
            self.imageUrl = savedUrl
            // print("Library \(imageUrl)")
        }
    }
    
    func removeFileFromDocumentsDirectory(fileUrl: URL) {
        _ = FileManager.default.removeFileFromDocumentsDirectory(fileUrl: fileUrl)
    }
    
    //MARK:- Text View Delegate Method
    func textViewDidBeginEditing(_ textView: UITextView) {
        //let searchVC = GMSAutocompleteViewController()
        //searchVC.delegate = self
        //self.window?.rootViewController?.present(searchVC, animated: true, completion: nil)
    }
    
   // Google Places Delegate Methods
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       // print("Place Name : \(place.name)")
        print("Place Address : \(place.formattedAddress ?? "null")")
        textAddress.text = place.formattedAddress
        self.appDel.dissmissController()
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.appDel.dissmissController()
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Cancelled")
        self.appDel.dissmissController()
    }

    //MARK:- SetUp Drop Down
    func accountDropDown() {
        accountTypeDropDown.anchorView = buttonAccountType
        accountTypeDropDown.dataSource = dropDownDataArray
        accountTypeDropDown.selectionAction = { [unowned self]
            (index, item) in
            self.buttonAccountType.setTitle(item, for: .normal)
            self.accountType = item
            print(self.accountType)
        }
    }
    
    @IBAction func actionChangePassword(_ sender: UIButton) {
        btnChangePassword?()
    }
   
    @IBAction func actionAccountType(_ sender: Any) {
        btnDropDown?()
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
      //  btnUpdate?()
        
        guard let name = txtName.text else {
            return
        }
        guard let phone = txtPhone.text else {
            return
        }
        
        guard let location = textAddress.text else {
            return
        }
        guard let introduction = txtIntroduction.text else {
            return
        }
        guard let facebook = txtFacebook.text else {
            return
        }
        guard let twitter = txtTwitter.text else {
            return
        }
        guard let linkedIn = txtLinkedIn.text else {
            return
        }
        guard let google = txtGooglePlus.text else {
            return
        }
        let custom: [String: Any] = [
            "_sb_profile_facebook": facebook,
            "_sb_profile_twitter" : twitter,
            "_sb_profile_linkedin" : linkedIn,
            "_sb_profile_google-plus" : google
        ]
        print(custom)


        let parameters: [String: Any] = [
            "user_name": name,
            "phone_number": phone,
            "account_type": accountType,
            "location": location,
            "user_introduction" : introduction,
            "social_icons": custom
        ]
        
        print(parameters)
        self.updateProfile(params: parameters as NSDictionary)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        self.btnDelete?()
    }
    
    
    //MARK:- API CALL
    
     func imageUpdate(fileUrl: URL, fileName: String, uploadProgress: @escaping(Int)-> Void ,success: @escaping(UpdateImageRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.imageUpdate
        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: fileName, params: nil, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)

        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            let objImage = UpdateImageRoot(fromDictionary: dictionary)
            success(objImage)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    func uploadImage() {
       
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: containerView)
        
       //let editprofile = EditProfileController()
        //editprofile.showLoader()
        imageUpdate(fileUrl: imageUrl, fileName: fileName,uploadProgress: { (uploadProgress) in
            print(uploadProgress)
    
        }, success: { (sucessResponse) in
            self.uploadingProgressBar.dismiss(animated: true)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if sucessResponse.success {
                let alert = AlertView.prepare(title: "", message: sucessResponse.message , okAction: {
                    self.removeFileFromDocumentsDirectory(fileUrl: self.imageUrl)
                    //post notification to update data in side menu
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.updateUserProfile), object: nil)
                   self.appDel.popController()
                })
                self.appDel.presentController(ShowVC: alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: sucessResponse.message)
                self.appDel.presentController(ShowVC: alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDel.presentController(ShowVC: alert)
        }
    }
    
    func updateProfile(params: NSDictionary) {
        let editprofile = EditProfileController()
        editprofile.showLoader()
        UserHandler.profileUpdate(parameters: params, success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDel.presentController(ShowVC: alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.appDel.presentController(ShowVC: alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.appDel.presentController(ShowVC: alert)
        }
    }
}
