//
//  HomeController.swift
//  PalmTree
//
//  Created by SprintSols on 13/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseCore
import FirebaseInstanceID
import GoogleMobileAds
import IQKeyboardManagerSwift

var admobDelegate = AdMobDelegate()
var currentVc: UIViewController!

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NVActivityIndicatorViewable, AddDetailDelegate, CategoryDetailDelegate, UISearchBarDelegate, MessagingDelegate,UNUserNotificationCenterDelegate, NearBySearchDelegate, BlogDetailDelegate , LocationCategoryDelegate, SwiftyAdDelegate , GADInterstitialDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var categoriesView: UIView!
    
    let keyboardManager = IQKeyboardManager.sharedManager()
    
    //MARK:- Properties
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    var defaults = UserDefaults.standard
    var dataArray = [HomeSlider]()
    var categoryArray = [CatIcon]()
    var featuredArray = [HomeAdd]()
    var latestAdsArray = [HomeAdd]()
    var blogObj: HomeLatestBlog?
    var catLocationsArray = [CatLocation]()
    var nearByAddsArray = [HomeAdd]()
    var searchSectionArray = [HomeSearchSection]()
    
    var isAdPositionSort = false
    var isShowLatest = false
    var isShowBlog = false
    var isShowNearby = false
    var isShowFeature = false
    var isShowLocationButton = false
    var isShowCategoryButton = false
    
    var featurePosition = ""
    var animalSectionTitle = ""
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    var addPosition = ["search_Cell"]
    var barButtonItems = [UIBarButtonItem]()
    
    var viewAllText = ""
    var catLocationTitle = ""
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    //var homeTitle = ""
    var numberOfColumns:CGFloat = 0
    var heightConstraintTitleLatestad = 0
    var heightConstraintTitlead = 0
    var inters : GADInterstitial!
    
    var isAdvanceSearch:Bool = false
    var latColHeight: Double = 0
    var fetColHeight: Double = 0
    var SliderColHeight: Double = 0
    var showVertical:Bool = false
    var showVerticalAds: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd:String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.isNavigationBarHidden = true
        inters = GADInterstitial(adUnitID:"ca-app-pub-2596107136418753/4126592208")
        let request = GADRequest()
        // request.testDevices = [(kGADSimulatorID as! String),"79e5cafdc063cca47a7b4158f482669ad5a74c2b"]
        inters.load(request)
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Home Controller")
        self.adForest_sendFCMToken()
        self.subscribeToTopicMessage()
        self.showLoader()
        self.homeData()
//        self.addLeftBarButtonWithImage()
//        self.navigationButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
//            self.oltAddPost.isHidden = false
//        }
        currentVc = self
                //self.homeData()
        
    }
    
    @objc func refreshTableView() {
        self.homeData()
        //        self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 0.5)
        self.refreshControl.endRefreshing()
    }
    
    func fillCategoriesView()
    {
        for view in categoriesView.subviews
        {
            view.removeFromSuperview()
        }
        
        let screenSize = UIScreen.main.bounds
        
        let width = ((screenSize.width-10)/5)
        
        var xAxis = 5
        
        for i in 0..<categoryArray.count
        {
            if i < 4
            {
                let objData = categoryArray[i]
                
                let view = UIView(frame: CGRect(x: xAxis, y: 0, width: Int(width), height: 70))
                
                let imgView = UIImageView(frame: CGRect(x: 0, y: 10, width: Int(width) - 6, height: 30))
                imgView.contentMode = .scaleAspectFit
                if let imgUrl = URL(string: objData.img.encodeUrl()) {
                    imgView.sd_setShowActivityIndicatorView(true)
                    imgView.sd_setIndicatorStyle(.gray)
                    imgView.sd_setImage(with: imgUrl, completed: nil)
                }
                
                let lblName = UILabel(frame: CGRect(x: 0, y: 45, width: Int(width) - 6, height: 15))
                lblName.font = UIFont.systemFont(ofSize: 11.0)
                lblName.textAlignment = .center
                if let name = objData.name {
                    lblName.text = name
                }
                
                let btn = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 70))
                btn.tag = 1000 + i
                btn.addTarget(self, action: #selector(catBtnAction(button:)), for: .touchUpInside)

                view.addSubview(imgView)
                view.addSubview(lblName)
                view.addSubview(btn)
                categoriesView.addSubview(view)
                
                xAxis += Int(width)
            }
            else
            {
                break
            }
        }
        
        let view = UIView(frame: CGRect(x: xAxis, y: 0, width: Int(width), height: 70))
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 10, width: Int(width) - 6, height: 30))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named : "more")
        
        let lblName = UILabel(frame: CGRect(x: 0, y: 45, width: Int(width) - 6, height: 15))
        lblName.font = UIFont.systemFont(ofSize: 11.0)
        lblName.textAlignment = .center
        lblName.text = "More"
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: 70))
        btn.addTarget(self, action: #selector(moreBtnAction(button:)), for: .touchUpInside)
        view.addSubview(imgView)
        view.addSubview(lblName)
        view.addSubview(btn)
        categoriesView.addSubview(view)
    }
    
    @objc func catBtnAction(button:UIButton)
    {
        
    }
    
    @objc func moreBtnAction(button:UIButton)
    {
        
    }
    
    //MARK:- Topic Message
    func subscribeToTopicMessage() {
        if defaults.bool(forKey: "isLogin") {
            Messaging.messaging().shouldEstablishDirectChannel = true
            Messaging.messaging().subscribe(toTopic: "global")
        }
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- go to add detail controller
    func goToAddDetail(ad_id: Int) {
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        addDetailVC.ad_id = ad_id
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    //MARK:- go to category detail
    func goToCategoryDetail(id: Int) {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.categoryID = id
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- Go to Location detail
    func goToCLocationDetail(id: Int) {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.categoryID = id
        categoryVC.isFromLocation = true
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- Go to blog detail
    func blogPostID(ID: Int) {
        let blogDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailController") as! BlogDetailController
        blogDetailVC.post_id = ID
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
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
        //        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //            HomeButton.isHidden = true
        //        }
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
        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
            locationButton.isHidden = true
        }
        
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
        //       if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //           searchButton.isHidden = true
        //       }
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
    
    //MARK:- AdMob Delegate Methods
    
    func swiftyAdDidOpen(_ swiftyAd: SwiftyAd) {
        print("Open")
    }
    
    func swiftyAdDidClose(_ swiftyAd: SwiftyAd) {
        print("Close")
    }
    
    func swiftyAd(_ swiftyAd: SwiftyAd, didRewardUserWithAmount rewardAmount: Int) {
        print(rewardAmount)
    }
    
    //MARK:- IBActions
    @IBAction func menuBtnAction(_ button: UIButton)
    {
        if button.tag == 1002
        {
            
        }
        else if button.tag == 1003
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
                self.navigationController?.pushViewController(adPostVC, animated: true)
            }
        }
        else if button.tag == 1004
        {
            
        }
        else if button.tag == 1005
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                
            }
        }
    }
    
    @IBAction func actionAddPost(_ sender: UIButton)
    {
        let notVerifyMsg = UserDefaults.standard.string(forKey: "not_Verified")
        let can = UserDefaults.standard.bool(forKey: "can")
        
        if defaults.bool(forKey: "isLogin") == false
        {
            var msgLogin = ""
            
            if let msg = self.defaults.string(forKey: "notLogin") {
                msgLogin = msg
            }
            
            let alert = Constants.showBasicAlert(message: msgLogin)
            self.presentVC(alert)
            
        }
        else if can == false
        {
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
            
        }
        else
        {
            let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
            self.navigationController?.pushViewController(adPostVC, animated: true)
        }
    }
    
    //MARK:- API Call
    
    //get home data
    func homeData() {
        
        dataArray.removeAll()
        categoryArray.removeAll()
        featuredArray.removeAll()
        latestAdsArray.removeAll()
        
        catLocationsArray.removeAll()
        nearByAddsArray.removeAll()
        searchSectionArray.removeAll()
        addPosition.removeAll()
        
        AddsHandler.homeData(success: { (successResponse) in
            self.stopAnimating()
            
            if successResponse.success {
                
                self.title = successResponse.data.pageTitle
                if let column = successResponse.data.catIconsColumn {
                    let columns = Int(column)
                    self.numberOfColumns = CGFloat(columns!)
                }
                //To Show Title After Search Bar Hidden
                self.viewAllText = successResponse.data.viewAll
                
                //Get value of show/hide buttons of location and categories
                if successResponse.data.catIconsColumnBtn != nil {
                    self.isShowCategoryButton = successResponse.data.catIconsColumnBtn.isShow
                    print(self.isShowCategoryButton)
                }
                if successResponse.data.catLocationsBtn != nil {
                    self.isShowLocationButton = successResponse.data.catLocationsBtn.isShow
                }
                UserDefaults.standard.set(successResponse.data.ad_post.can_post, forKey: "can")
                //UserDefaults.standard.set(true, forKey: "can")
                if let feature = successResponse.data.isShowFeatured {
                    self.isShowFeature = feature
                }
                if let feature = successResponse.data.featuredPosition {
                    self.featurePosition = feature
                }
                self.categoryArray = successResponse.data.catIcons
                self.dataArray = successResponse.data.sliders
                
                //Check Feature Ads is on or off and set add Position Sorter
                if self.isShowFeature {
                    self.featuredArray = successResponse.data.featuredAds.ads
                }
                if let isSort = successResponse.data.adsPositionSorter {
                    self.isAdPositionSort = isSort
                }
                self.addPosition = ["search_Cell"]
                if self.isAdPositionSort {
                    self.addPosition += successResponse.data.adsPosition
                    if let latest = successResponse.data.isShowLatest {
                        self.isShowLatest = latest
                    }
                    if self.isShowLatest {
                        self.latestAdsArray = successResponse.data.latestAds.ads
                    }
                    
                    if let showBlog = successResponse.data.isShowBlog {
                        self.isShowBlog = showBlog
                    }
                    if self.isShowBlog {
                        self.blogObj = successResponse.data.latestBlog
                    }
                    
                    if let showNearAds = successResponse.data.isShowNearby {
                        self.isShowNearby = showNearAds
                    }
                    if self.isShowNearby {
                        self.nearByTitle = successResponse.data.nearbyAds.text
                        if successResponse.data.nearbyAds.ads.isEmpty == false {
                            self.nearByAddsArray = successResponse.data.nearbyAds.ads
                        }
                    }
                    if successResponse.data.catLocations.isEmpty == false {
                        self.catLocationsArray = successResponse.data.catLocations
                        if let locationTitle = successResponse.data.catLocationsTitle {
                            self.catLocationTitle = locationTitle
                        }
                    }
                }
                AddsHandler.sharedInstance.objHomeData = successResponse.data
                AddsHandler.sharedInstance.objLatestAds = successResponse.data.latestAds
                AddsHandler.sharedInstance.topLocationArray = successResponse.data.appTopLocationList
                // Set Up AdMob Banner & Intersitial ID's
                UserHandler.sharedInstance.objAdMob = successResponse.settings.ads
                var isShowAd = false
                if let adShow = successResponse.settings.ads.show {
                    isShowAd = adShow
                }
                if isShowAd {
                    SwiftyAd.shared.delegate = self
                    var isShowBanner = false
                    var isShowInterstital = false
                    
                    if let banner = successResponse.settings.ads.isShowBanner {
                        isShowBanner = banner
                    }
                    if let intersitial = successResponse.settings.ads.isShowInitial {
                        isShowInterstital = intersitial
                    }
                    if isShowBanner {
                        SwiftyAd.shared.setup(withBannerID: successResponse.settings.ads.bannerId, interstitialID: "", rewardedVideoID: "")
                        
                        print(successResponse.settings.ads.bannerId)
                        
                        
                    }
                    //ca-app-pub-6905547279452514/6461881125
                    if isShowInterstital {
                        //                        SwiftyAd.shared.setup(withBannerID: "", interstitialID: successResponse.settings.ads.interstitalId, rewardedVideoID: "")
                        //                        SwiftyAd.shared.showInterstitial(from: self, withInterval: 1)
                        
                        
                        self.showAd()
                        
                        //self.perform(#selector(self.showAd), with: nil, afterDelay: Double(successResponse.settings.ads.timeInitial)!)
                        //self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(successResponse.settings.ads.time)!)
                        
                        self.perform(#selector(self.showAd), with: nil, afterDelay: Double(30))
                        self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(30))
                        
                        
                    }
                }
                // Here I set the Google Analytics Key
                var isShowAnalytic = false
                if let isShow = successResponse.settings.analytics.show {
                    isShowAnalytic = isShow
                }
                if isShowAnalytic {
                    if let analyticKey = successResponse.settings.analytics.id {
                        guard let gai = GAI.sharedInstance() else {
                            assert(false, "Google Analytics not configured correctly")
                            return
                        }
                        gai.tracker(withTrackingId: analyticKey)
                        gai.trackUncaughtExceptions = true
                    }
                }
                
                UserDefaults.standard.set(successResponse.data.ad_post.verMsg, forKey: "not_Verified")
                
                //Search Section Data
                self.searchSectionArray = [successResponse.data.searchSection]
                self.fillCategoriesView()
                
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
    
    @objc func showAd(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    @objc func showAd2(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    //MARK:- Send fcm token to server
    func adForest_sendFCMToken() {
        var fcmToken = ""
        if let token = defaults.value(forKey: "fcmToken") as? String {
            fcmToken = token
        } else {
            fcmToken = appDelegate.deviceFcmToken
        }
        let param: [String: Any] = ["firebase_id": fcmToken]
        print(param)
        AddsHandler.sendFirebaseToken(parameter: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            print(successResponse)
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- CollectionView Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArray.count
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  AddsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddsCollectionCell", for: indexPath) as! AddsCollectionCell
        
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
//        let objData = dataArray[indexPath.row]
        
        cell.lblName.text = "Car"
        cell.lblPrice.text = "$200"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
//        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: AddDetailController.className) as! AddDetailController
//        addDetailVC.ad_id = dataArray[indexPath.row].adId
//        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if Constants.isiPadDevice {
//            let width = collectionView.bounds.width/3.0
//            return CGSize(width: width, height: 220)
//        }
//        let width = collectionView.bounds.width/2.0
//        return CGSize(width: width, height: 220)
//    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView.isDragging {
//            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            UIView.animate(withDuration: 0.3, animations: {
//                cell.transform = CGAffineTransform.identity
//            })
//        }
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
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

