//
//  ProfileController.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class ProfileController: UIViewController , UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, SwiftyAdDelegate, UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate  {
    
    //MARK:- Outlets
    
    @IBOutlet weak var oltAdPost: UIButton! {
        didSet {
            oltAdPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltAdPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
            tableView.register(UINib(nibName: "AddsStatusCell", bundle: nil), forCellReuseIdentifier: "AddsStatusCell")
        }
    }
    
    //MARK:- Properties
    var dataArray = [ProfileDetailsData]()
    var socialArray = [ProfileDetailsAccountType]()
    let defaults = UserDefaults.standard
    
    var google = ""
    var facebook = ""
    var linkedin = ""
    var twitter = ""
    
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()

    var barButtonItems = [UIBarButtonItem]()
    
    
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftyAd.shared.delegate = self 
        self.googleAnalytics(controllerName: "Profile Controller")
        self.adMob()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.NotificationName.updateUserProfile), object: nil, queue: nil) { (notification) in
            self.adForest_profileDetails()
        }
        if defaults.bool(forKey: "isLogin") == false {
            self.oltAdPost.isHidden = true
        }
        
        
        navigationButtons()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addLeftBarButtonWithImage()
        self.adForest_profileDetails()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//         self.adForest_profileDetails()
//    }
    
    
    //MARK: - Custom
  
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func verifyNumberVC() {
        let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyNumberController") as! VerifyNumberController
        verifyVC.modalPresentationStyle = .overCurrentContext
        verifyVC.modalTransitionStyle = .crossDissolve
        verifyVC.dataToShow = UserHandler.sharedInstance.objProfileDetails
        self.presentVC(verifyVC)
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
                        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .top)
                    }
                    else {
                        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .bottom)
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
    
    
    //MARK:- AdMob Delegates
    func swiftyAdDidOpen(_ swiftyAd: SwiftyAd) {
        
    }
    
    func swiftyAdDidClose(_ swiftyAd: SwiftyAd) {
        
    }
    
    func swiftyAd(_ swiftyAd: SwiftyAd, didRewardUserWithAmount rewardAmount: Int) {
        
    }
    
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.isEmpty {
            return 0
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let objData = dataArray[indexPath.row]

        if section == 0 {
            let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            
            if objData.profileExtra.profileImg != nil{
                if let imgUrl = URL(string: objData.profileExtra.profileImg) {
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                }
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
                if obj.fieldName == "_sb_profile_linkedin" {
                    self.linkedin = obj.value
                    cell.btnLinkedIn.isHidden = false
                    cell.btnLinkedIn.setTitle(obj.value, for: .normal)
                }
                if obj.fieldName == "_sb_profile_facebook" {
                    self.facebook = obj.value
                    cell.btnFB.isHidden = false
                    cell.btnFB.setTitle(obj.value, for: .normal)
                }
                if obj.fieldName == "_sb_profile_twitter" {
                    self.twitter = obj.value
                    cell.btnTwitter.isHidden = false
                    cell.btnTwitter.setTitle(obj.value, for: .normal)
                }
                if obj.fieldName == "_sb_profile_google-plus" {
                    self.google = obj.value
                    cell.btnGoogle.isHidden = false
                    cell.btnGoogle.setTitle(obj.value, for: .normal)

                }
            }
            
            cell.btnLinkedIn.addTarget(self, action: #selector(ProfileController.linkedinClicked(_:)), for: .touchUpInside)
            cell.btnFB.addTarget(self, action: #selector(ProfileController.fbClicked(_:)), for: .touchUpInside)
            cell.btnTwitter.addTarget(self, action: #selector(ProfileController.twitterClicked(_:)), for: .touchUpInside)
            cell.btnGoogle.addTarget(self, action: #selector(ProfileController.googleClicked(_:)), for: .touchUpInside)
            
            
            if let editButtonTitle = objData.profileExtra.editText {
                cell.buttonEditProfile.setTitle(editButtonTitle, for: .normal)
            }
            cell.actionEdit = { () in
                let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
            
            return cell
        }
        else if section == 1 {
            let cell: AddsStatusCell = tableView.dequeueReusableCell(withIdentifier: "AddsStatusCell", for: indexPath) as! AddsStatusCell
            
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
            let cell: UserProfileInformationCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileInformationCell", for: indexPath) as! UserProfileInformationCell
            let detailsData = UserHandler.sharedInstance.objProfileDetails
            
            if let titleText = objData.pageTitle {
                cell.lblMyProfile.text = titleText
            }
            
            if let nameText = objData.displayName.key {
                cell.lblName.text = nameText
            }
            if let nameValue = objData.displayName.value {
                cell.lblNameValue.text = nameValue
            }
            if let emailText = objData.userEmail.key {
                cell.lblEmail.text = emailText
            }
            if let emailvalue = objData.userEmail.value {
                cell.lblEmailValue.text = emailvalue
            }
            
            if let phoneNumberText = objData.phone.key {
                cell.lblPhone.text = phoneNumberText
            }
            if let phoneNumberValue = objData.phone.value {
                cell.lblPhoneValue.text = phoneNumberValue
            }
            if let buttonVerificationTitle = detailsData?.extraText.isNumberVerifiedText {
                var attributedString = NSMutableAttributedString(string: "")
                let buttonTitle = NSMutableAttributedString(string: buttonVerificationTitle, attributes: cell.attributes)
                attributedString.append(buttonTitle)
                cell.buttonPhoneVerification.setAttributedTitle(attributedString, for: .normal)
            }
            
            var isVerificationOn = false
            if let isVerification = detailsData?.extraText.isVerificationOn {
                isVerificationOn = isVerification
            }
            
            if isVerificationOn {
                if (detailsData?.extraText.isNumberVerified)! {
                    cell.buttonPhoneVerification.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.phoneVerified)
                }
                else {
                    cell.buttonPhoneVerification.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.phoneNotVerified)
                    cell.clickNumberVerified = { () in
                        let alert = UIAlertController(title: detailsData?.extraText.sendSmsDialog.title, message: detailsData?.extraText.sendSmsDialog.text, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: detailsData?.extraText.sendSmsDialog.btnSend, style: .default, handler: { (okAcion) in
                            self.adForest_phoneNumberVerify()
                        })
                        let cancelAction = UIAlertAction(title: detailsData?.extraText.sendSmsDialog.btnCancel, style: .default, handler: nil)
                        alert.addAction(cancelAction)
                        alert.addAction(okAction)
                        self.presentVC(alert)
                    }
                }
            }
            else {
                cell.buttonPhoneVerification.isHidden = true
            }
            
            if let accountTypeText = objData.accountType.key {
                cell.lblAccountType.text = accountTypeText
            }
            
            if let accountTypeValue = objData.accountType.value {
                cell.lblAccountTypeValue.text = accountTypeValue
            }
            if let locationText = objData.location.key {
                cell.lblLocation.text = locationText
            }
            if let locationValue = objData.location.value {
                cell.lblLocationValue.text = locationValue
            }
            if let packageTypetext = objData.packageType.key {
                cell.lblPackageType.text = packageTypetext
            }
            if let packageValue = objData.packageType.value {
                cell.lblPackageTypeValue.text = packageValue
            }
            if let simpleAddtext = objData.simpleAds.key {
                cell.lblSimpleAds.text = simpleAddtext
            }
            if let simpleAddValue = objData.simpleAds.value {
                cell.lblSimpleAdsvalue.text = simpleAddValue
            }
            
            if let featureAddText = objData.featuredAds.key {
                cell.lblFeatureAds.text = featureAddText
            }
            if let featureAddValue = objData.featuredAds.value {
                cell.lblFeatureAdsValue.text = featureAddValue
            }
            if let bumpAddText = objData.bumpAds.key {
                cell.lblBumpAds.text = bumpAddText
            }
            if let bumpAddValue = objData.bumpAds.value {
                cell.lblBumpAdsValue.text = bumpAddValue
            }
            if let expireDateText = objData.expireDate.key {
                cell.lblExpiryDate.text = expireDateText
            }
            if let expireValue = objData.expireDate.value {
                cell.lblExpiryDateValue.text = expireValue
            }
            var isShowBlockUser = false
            if let isShowUser = objData.blockedUsersShow {
                isShowBlockUser = isShowUser
            }
            
            if isShowBlockUser {
                cell.oltBlockedUsers.isHidden = false
                if let btnText = objData.blockedUsers.value {
                    cell.oltBlockedUsers.setTitle(btnText, for: .normal)
                }
                if let lblText = objData.blockedUsers.key {
                    cell.lblBlockedUser.text = lblText
                }
                cell.btnBlockUser = { () in
                    let blockedVC = self.storyboard?.instantiateViewController(withIdentifier: "BlockedUserController") as! BlockedUserController
                    self.navigationController?.pushViewController(blockedVC, animated: true)
                }
            } else {
                cell.oltBlockedUsers.isHidden = true
                cell.lblBlockedUser.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0 {
            let userRatingVC = self.storyboard?.instantiateViewController(withIdentifier: "UserRatingController") as! UserRatingController
            self.navigationController?.pushViewController(userRatingVC, animated: true)
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            return 105
        case 1:
            return 65
        case 2:
            return 550
        default:
            return 0
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionAdpost(_ sender: UIButton) {
        
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
                    //self.appDelegate.moveToProfile()
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
    //action social Icons Clicked

    @objc func linkedinClicked(_ sender: UIButton){
        print(sender.currentTitle)
          let inValidUrl = UserDefaults.standard.string(forKey: "InValidUrl")

                 if #available(iOS 10.0, *) {
                     if verifyUrl(urlString: linkedin) == false {
                        let alert = Constants.showBasicAlert(message: inValidUrl!)
                        self.presentVC(alert)
                     }else{
                        print(linkedin)
                         UIApplication.shared.open(URL(string: linkedin)!, options: [:], completionHandler: nil)
                     }
                     
                 } else {
                     if verifyUrl(urlString: linkedin) == false {
                        Constants.showBasicAlert(message: inValidUrl!)
                     }else{
                         UIApplication.shared.openURL(URL(string: linkedin)!)
                     }
                 }
          print(sender.currentTitle)
          
          
      }
    @objc func fbClicked(_ sender: UIButton){
            let inValidUrl = UserDefaults.standard.string(forKey: "InValidUrl")

                   if #available(iOS 10.0, *) {
                       if verifyUrl(urlString: facebook) == false {
                        let alert = Constants.showBasicAlert(message: inValidUrl!)
                           self.presentVC(alert)                       }else{
                           UIApplication.shared.open(URL(string: facebook)!, options: [:], completionHandler: nil)
                       }

                   } else {
                       if verifyUrl(urlString: facebook) == false {
                        Constants.showBasicAlert(message: inValidUrl!)
                       }else{
                           UIApplication.shared.openURL(URL(string: facebook)!)
                       }
                   }
            print(sender.currentTitle)


        }
    @objc func twitterClicked(_ sender: UIButton){
            let inValidUrl = UserDefaults.standard.string(forKey: "InValidUrl")

                   if #available(iOS 10.0, *) {
                       if verifyUrl(urlString: twitter) == false {
                        let alert = Constants.showBasicAlert(message: inValidUrl!)
                           self.presentVC(alert)                       }else{
                           UIApplication.shared.open(URL(string: twitter)!, options: [:], completionHandler: nil)
                       }

                   } else {
                       if verifyUrl(urlString: twitter) == false {
                        Constants.showBasicAlert(message: inValidUrl!)
                       }else{
                           UIApplication.shared.openURL(URL(string: twitter)!)
                       }
                   }
            print(sender.currentTitle)


        }
    @objc func googleClicked(_ sender: UIButton){
            let inValidUrl = UserDefaults.standard.string(forKey: "InValidUrl")

                   if #available(iOS 10.0, *) {
                       if verifyUrl(urlString: google) == false {
                        let alert = Constants.showBasicAlert(message: inValidUrl!)
                        self.presentVC(alert)

                       }else{
                           UIApplication.shared.open(URL(string: google)!, options: [:], completionHandler: nil)
                       }

                   } else {
                       if verifyUrl(urlString: google) == false {
                        Constants.showBasicAlert(message: inValidUrl!)
                       }else{
                           UIApplication.shared.openURL(URL(string: google)!)
                       }
                   }
            print(sender.currentTitle)


        }

      func verifyUrl (urlString: String?) -> Bool {
             //Check for nil
             if let urlString = urlString {
                 // create NSURL instance
                 if let url = NSURL(string: urlString) {
                     // check if your application can open the NSURL instance
                     return UIApplication.shared.canOpenURL(url as URL)
                 }
             }
             return false
         }
    //MARK:- API Call
    
    // Profile Details
    func adForest_profileDetails() {
        self.showLoader()
        UserHandler.profileGet(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray = [successResponse.data]
                self.socialArray = successResponse.data.socialIcons
                self.title = successResponse.extraText.profileTitle
                UserHandler.sharedInstance.objProfileDetails = successResponse
                self.tableView.reloadData()
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
    
    //Verify Phone Number
    func adForest_phoneNumberVerify() {
        self.showLoader()
        UserHandler.verifyPhone(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.verifyNumberVC()
                })
                self.presentVC(alert)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
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
            self.adForest_nearBySearch(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
            print(param)
            self.adForest_nearBySearch(param: param as NSDictionary)
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
    func adForest_nearBySearch(param: NSDictionary) {
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



class UserProfileInformationCell: UITableViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblMyProfile: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNameValue: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblEmailValue: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblPhoneValue: UILabel!
    @IBOutlet weak var buttonPhoneVerification: UIButton!
    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var lblAccountTypeValue: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLocationValue: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblPackageTypeValue: UILabel!
    @IBOutlet weak var lblSimpleAds: UILabel!
    @IBOutlet weak var lblSimpleAdsvalue: UILabel!
    @IBOutlet weak var lblFeatureAds: UILabel!
    @IBOutlet weak var lblFeatureAdsValue: UILabel!
    @IBOutlet weak var lblBumpAds: UILabel!
    @IBOutlet weak var lblBumpAdsValue: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblExpiryDateValue: UILabel!
    @IBOutlet weak var lblBlockedUser: UILabel!
    
    @IBOutlet weak var oltBlockedUsers: UIButton!
    //MARK:- Properties
    
    var clickNumberVerified: (()->())?
    var btnBlockUser: (()->())?
    
    var attributes : [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
        NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.underlineStyle : 1]
    
    //MARK:- view Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func actionPhoneVerified(_ sender: UIButton) {
        clickNumberVerified?()
    }
    
    @IBAction func actionBlockedUser(_ sender: UIButton) {
        self.btnBlockUser?()
    }


}





