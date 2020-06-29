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

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, AddDetailDelegate, CategoryDetailDelegate, UISearchBarDelegate, MessagingDelegate,UNUserNotificationCenterDelegate, NearBySearchDelegate, BlogDetailDelegate , LocationCategoryDelegate, SwiftyAdDelegate , GADInterstitialDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "SearchSectionCell", bundle: nil), forCellReuseIdentifier: "SearchSectionCell")
            tableView.addSubview(refreshControl)
        }
    }
    
    let keyboardManager = IQKeyboardManager.sharedManager()
    
    //MARK:- Properties
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    var defaults = UserDefaults.standard
    var dataArray = [HomeSlider]()
    var featuredArray = [HomeAdd]()
    var latestAdsArray = [HomeAdd]()
    var blogObj : HomeLatestBlog?
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
    
    //MenuButtons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPalmtree: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    
    @IBOutlet weak var lblSearch: UILabel!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeVC = self
        
         self.navigationController?.isNavigationBarHidden = true
        inters = GADInterstitial(adUnitID:"ca-app-pub-2596107136418753/4126592208")
        let request = GADRequest()
        // request.testDevices = [(kGADSimulatorID as! String),"79e5cafdc063cca47a7b4158f482669ad5a74c2b"]
        inters.load(request)
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Home Controller")
        self.sendFCMToken()
        self.subscribeToTopicMessage()
        self.showLoader()
        self.homeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSearch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            changeMenuButtons()
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVc = self
                //self.homeData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func refreshTableView() {
        self.homeData()
        //        self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 0.5)
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func changeMenuButtons()
    {
        btnHome.setImage(UIImage(named: "home_active_" + languageCode), for: .normal)
        btnPalmtree.setImage(UIImage(named: "mypalmtree_" + languageCode), for: .normal)
        btnPost.setImage(UIImage(named: "post_" + languageCode), for: .normal)
        btnWishlist.setImage(UIImage(named: "wishlist_" + languageCode), for: .normal)
        btnMessages.setImage(UIImage(named: "messages_" + languageCode), for: .normal)
        
        btnHome.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPalmtree.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnWishlist.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnMessages.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
//        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
//        addDetailVC.ad_id = ad_id
//        self.navigationController?.pushViewController(addDetailVC, animated: true)
        
        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    //MARK:- go to category detail
    func goToCategoryDetail() {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- go to ad list
    func goToAdFilterListVC() {
        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        self.navigationController?.pushViewController(adFilterListVC, animated: true)
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
            self.nearBySearch(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
            print(param)
            self.nearBySearch(param: param as NSDictionary)
        }
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
        }
        else
        {
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
    
    
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = indexPath.section

        if section == 0
        {
            let cell: CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell

            cell.numberOfColums = self.numberOfColumns
            cell.categoryArray  = categoryArray
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
        }
        else if section == 1
        {
            let cell: AddsTableCell  = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell

//            let objData = dataArray[indexPath.row]
//            let data = AddsHandler.sharedInstance.objHomeData

//            cell.btnViewAll = { () in
//                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
//                categoryVC.categoryID = objData.catId
//                self.navigationController?.pushViewController(categoryVC, animated: true)
//            }
            
            cell.locationBtnAction = { () in
                let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                self.navigationController?.pushViewController(locationVC, animated: true)
            }
//            cell.dataArray = objData.data
            cell.delegate = self
            cell.reloadData()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var totalHeight : CGFloat = 0
        var height: CGFloat = 0
          
        if section == 0
        {
            let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewSettings.column)
            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing)
            height =  totalHeight
        }
        else if section == 1
        {
            height = 1080
        }
            
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    
//    private var finishedLoadingInitialTableCells = false
//     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        var lastInitialDisplayableCell = false
//
//        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
////        if favorites.itemes.count > 0 && !finishedLoadingInitialTableCells {
//            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
//                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
//                lastInitialDisplayableCell = true
//            }
////        }
//
//        if !finishedLoadingInitialTableCells {
//
//            if lastInitialDisplayableCell {
//                finishedLoadingInitialTableCells = true
//            }
//
//            //animates the cell as it is being displayed for the first time
//            do {
//                let startFromHeight = tableView.frame.height
//                cell.layer.transform = CATransform3DMakeTranslation(0, startFromHeight, 0)
//                let delay = Double(indexPath.row) * 0.2
//
//                UIView.animate(withDuration: 0.2, delay: delay, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
//                    do {
//                        cell.layer.transform = CATransform3DIdentity
//                    }
//                }) { (success:Bool) in
//
//                }
//            }
//        }
//    }

    
    
    //MARK:- IBActions
    @IBAction func searchBtnAction(_ button: UIButton)
    {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @IBAction func menuBtnAction(_ button: UIButton)
    {
        if button.tag == 1002
        {
            let myAdsVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAdsController") as! MyAdsController
            self.navigationController?.pushViewController(myAdsVC, animated: false)
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
                let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostVC") as! AdPostVC
                let navController = UINavigationController(rootViewController: adPostVC)
                navController.navigationBar.isHidden = true
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated:true, completion: nil)
            }
        }
        else if button.tag == 1004
        {
            if defaults.bool(forKey: "isLogin") == false
            {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let navController = UINavigationController(rootViewController: loginVC)
                self.present(navController, animated:true, completion: nil)
            }
            else
            {
                let favouritesVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
                self.navigationController?.pushViewController(favouritesVC, animated: false)
            }
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
                let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
                self.navigationController?.pushViewController(messagesVC, animated: false)
            }
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
                categoryArray = successResponse.data.catIcons
                //For testing purpose
                if languageCode == "ar"
                {
                    categoryArray[0].name = "السيارات";
                    categoryArray[1].name = "للبيع";
                    categoryArray[2].name = "الوظائف";
                    categoryArray[3].name = "أجهزة كهربائية";
                    categoryArray[4].name = "اثاث";
                    categoryArray[5].name = "حيوانات أليفة";
                    categoryArray[6].name = "خاصية";
                    categoryArray[7].name = "المزيد";
                }
                
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
                        
                        self.tableView.translatesAutoresizingMaskIntoConstraints = false
                        if successResponse.settings.ads.position == "top" {
                            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
                            SwiftyAd.shared.showBanner(from: self, at: .top)
                        } else {
                            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
                            SwiftyAd.shared.showBanner(from: self, at: .bottom)
                        }
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
                
                self.tableView.reloadData()
                
//                let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height)
//                self.tableView.setContentOffset(scrollPoint, animated: true)
                let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height + self.tableView.contentSize.height)
                self.tableView.setContentOffset(scrollPoint, animated: true)
                self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 0.5)
                
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
    
    @objc func nokri_showNavController1(){
        
        let scrollPoint = CGPoint(x: 0, y: 0)
        self.tableView.setContentOffset(scrollPoint, animated: true)
        
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
    func sendFCMToken() {
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
