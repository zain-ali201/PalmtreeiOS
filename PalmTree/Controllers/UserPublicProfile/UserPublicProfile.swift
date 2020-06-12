//
//  UserPublicProfile.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Cosmos
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class UserPublicProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable,UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var scrollBar: UIScrollView!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var containerViewProfile: UIView! {
        didSet {
            containerViewProfile.addShadowToView()
        }
    }
    
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnLinkedIn: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVerification: UILabel!
    @IBOutlet weak var lblLastLogin: UILabel!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var containerViewIntroduction: UIView!{
        didSet{
            if let mainColor = self.defaults.string(forKey: "mainColor"){
                self.containerViewIntroduction.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblIntro: UILabel!
    @IBOutlet weak var containerViewAdds: UIView!
    @IBOutlet weak var lblSoldAds: UILabel!
    @IBOutlet weak var lblAllAds: UILabel!
    @IBOutlet weak var lblInactiveAds: UILabel!
    @IBOutlet weak var collectionViewAds: UICollectionView! {
        didSet {
            collectionViewAds.delegate = self
            collectionViewAds.dataSource = self
        }
    }
    
    //MARK:- Properties
    var dataArray = [PublicProfileAdd]()
    var socialArray = [PublicProfileIntro]()
    let defaults = UserDefaults.standard
    var userID = ""
    var authorID = 0
    
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
    var google = ""
    var facebook = ""
    var linkedin = ""
    var twitter = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.adMob()
        self.googleAnalytics(controllerName: "User Public Profile")
        navigationButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let param: [String: Any] = ["user_id": userID]
        self.publicProfileData(parameter: param as NSDictionary)
    }
    
    //MARK: - Custom
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

                    if objData?.position == "top" {
                        self.containerViewProfile.translatesAutoresizingMaskIntoConstraints = false
                        self.containerViewProfile.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .top)
                    }
                    else {
                        self.collectionViewAds.translatesAutoresizingMaskIntoConstraints = false
                        self.collectionViewAds.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 50).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .bottom)
                    }
                }
                if isShowInterstital {
                    SwiftyAd.shared.setup(withBannerID: "", interstitialID: (objData?.interstitalId)!, rewardedVideoID: "")
                    SwiftyAd.shared.showInterstitial(from: self)
                }
            }
        }
    }
    
    
    func populateData() {
        if UserHandler.sharedInstance.objPublicProfile != nil {
            let objData = UserHandler.sharedInstance.objPublicProfile
            
            if let pageTitle = objData?.pageTitle {
                self.title = pageTitle
            }
            if let imgUrl = URL(string: (objData?.profileExtra.profileImg)!) {
                self.imgProfile.sd_setShowActivityIndicatorView(true)
                self.imgProfile.sd_setIndicatorStyle(.gray)
                self.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData?.profileExtra.displayName {
                self.lblName.text = name
            }
            if let isVerified = objData?.profileExtra.verifyButon.text {
                self.lblVerification.text = isVerified
                self.lblVerification.backgroundColor = Constants.hexStringToUIColor(hex: (objData?.profileExtra.verifyButon.color)!)
            }
            if let loginTime = objData?.profileExtra.lastLogin {
                self.lblLastLogin.text = loginTime
            }
            if let ratingBar = objData?.profileExtra.rateBar.number {
                self.ratingBar.settings.updateOnTouch = false
                self.ratingBar.settings.fillMode = .precise
                self.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
                self.ratingBar.rating = Double(ratingBar)!
            }
            
            if let ratingText = objData?.profileExtra.rateBar.text {
                self.ratingBar.text = ratingText
            }
           
            for obj in socialArray {
                if obj.fieldName == "_sb_profile_linkedin" {
                    self.linkedin = obj.value
                    self.btnLinkedIn.setTitle(obj.value, for: .normal)
                }
                if obj.fieldName == "_sb_profile_facebook" {
                    self.facebook = obj.value
                    self.btnFB.setTitle(obj.value, for: .normal)
                }
                if obj.fieldName == "_sb_profile_twitter" {
                    self.twitter = obj.value
                    self.btnTwitter.setTitle(obj.value, for: .normal)
                }
                if obj.fieldName == "_sb_profile_google-plus" {
                    self.google = obj.value
                    self.btnGoogle.setTitle(obj.value, for: .normal)
                    
                }
            }
            self.btnLinkedIn.addTarget(self, action: #selector(UserPublicProfile.linkedinClicked(_:)), for: .touchUpInside)
            self.btnFB.addTarget(self, action: #selector(UserPublicProfile.fbClicked(_:)), for: .touchUpInside)
            self.btnTwitter.addTarget(self, action: #selector(UserPublicProfile.twitterClicked(_:)), for: .touchUpInside)
            self.btnGoogle.addTarget(self, action: #selector(UserPublicProfile.googleClicked(_:)), for: .touchUpInside)
            
                       
            
            guard let introText = objData?.introduction.value else {return}
            
            if introText == "" {
                containerViewIntroduction.isHidden = true
                containerViewAdds.translatesAutoresizingMaskIntoConstraints = false
                containerViewAdds.topAnchor.constraint(equalTo: self.containerViewProfile.bottomAnchor, constant: 8).isActive = true
            } else {
                self.lblIntro.text = introText
            }
          
            if let soldAds = objData?.profileExtra.adsSold {
                self.lblSoldAds.text = soldAds
            }
            if let allAds = objData?.profileExtra.adsTotal {
                self.lblAllAds.text = allAds
            }
            if let inactiveAds = objData?.profileExtra.adsInactive {
                self.lblInactiveAds.text = inactiveAds
            }
            for authorid in (objData?.ads)! {
                if let author_id = authorid.adAuthorId {
                    self.authorID = author_id
                    break
                }
            }
        }
        else {
            print("Empty")
        }
    }
    
    //MARK:- Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PublicProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublicProfileCell", for: indexPath) as! PublicProfileCell
        let objData = dataArray[indexPath.row]
        
        for image in objData.adImages {
            if let imgUrl = URL(string: image.thumb) {
                cell.imgPic.sd_setShowActivityIndicatorView(true)
                cell.imgPic.sd_setIndicatorStyle(.gray)
                cell.imgPic.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        if let name = objData.adTitle {
            cell.lblName.text = name
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        if let addStatus = objData.adStatus.statusText {
            cell.lblType.text = addStatus
        }
        
        let statusType = objData.adStatus.status
        
        if statusType == "expired" {
            cell.lblType.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.expired)
        }
        else if statusType == "active" {
            cell.lblType.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.active)
        }
        else if statusType == "sold" {
            cell.lblType.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.sold)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        detailVC.ad_id = dataArray[indexPath.row].adId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.isiPadDevice {
            let width = collectionView.bounds.width/3.0
            return CGSize(width: width, height: 200)
        }
        let width = collectionView.bounds.width/2.0
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
       let objData = UserHandler.sharedInstance.objPublicProfile
        var currentPage = objData?.pagination.currentPage
        let maximumPage = objData?.pagination.maxNumPages
        
        var user_id = ""
        if let userId = objData?.profileExtra.id {
            user_id = userId
        }
        
        if indexPath.row == dataArray.count - 1 && currentPage! < maximumPage! {
            currentPage = currentPage! + 1
            let param: [String: Any] = ["user_id": user_id ,"page_number": currentPage!]
            print(param)
            self.loadMoreData(parameter: param as NSDictionary)
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionProfileRating(_ sender: Any) {
        let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: "PublicUserRatingController") as! PublicUserRatingController
        ratingVC.adAuthorID = String(authorID)
        self.navigationController?.pushViewController(ratingVC, animated: true)
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

    //MARK:- Api Calls
    func publicProfileData(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.userPublicProfile(params: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                print(successResponse.data)
                self.dataArray = successResponse.data.ads
                UserHandler.sharedInstance.objPublicProfile = successResponse.data
                self.socialArray = successResponse.data.socialIcons
                self.populateData()
                self.collectionViewAds.reloadData()
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
    
    func loadMoreData(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.userPublicProfile(params: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                print(successResponse.data)
                self.dataArray.append(contentsOf: successResponse.data.ads )
                UserHandler.sharedInstance.objPublicProfile = successResponse.data
                self.populateData()
                self.collectionViewAds.reloadData()
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

