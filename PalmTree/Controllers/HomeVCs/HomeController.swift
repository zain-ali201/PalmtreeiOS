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
import IQKeyboardManagerSwift
import CoreLocation

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, AddDetailDelegate, CategoryDetailDelegate, UISearchBarDelegate, MessagingDelegate,UNUserNotificationCenterDelegate , UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
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
        if let mainColor = defaults.string(forKey: "mainColor") {
            refreshControl.tintColor = Constants.hexStringToUIColor(hex: mainColor)
        }
        
        return refreshControl
    }()
    
    var defaults = UserDefaults.standard
    var latestAdsArray = [AdsJSON]()

    var latitude: Double = 0
    var longitude: Double = 0

    
    //MenuButtons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPalmtree: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    
    @IBOutlet weak var btnSearch: UIButton!
    
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    var fromVC = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetail?.displayName = defaults.string(forKey: "displayName") ?? ""
        userDetail?.id = defaults.integer(forKey: "id") 
        userDetail?.phone = defaults.string(forKey: "phone") ?? ""
        userDetail?.profileImg = defaults.string(forKey: "profileImg") ?? ""
        userDetail?.userEmail = defaults.string(forKey: "userEmail") ?? ""
        
        homeVC = self
        
        locationManager.requestWhenInUseAuthorization()
        
        //Location manager
        getGPSLocation()
        
        self.navigationController?.isNavigationBarHidden = true
       
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
            btnSearch.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnSearch.titleLabel?.textAlignment = .right
            changeMenuButtons()
        }
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentVc = self
                
        if fromVC == "PostAd"
        {
            fromVC = ""
            self.homeData()
        }
        
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func refreshTableView() {
        self.homeData()
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    //MARK:- Cutom Functions
    
    func getGPSLocation()
    {
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            
            if currentLoc != nil
            {
                userDetail?.currentLocation = currentLoc
                userDetail?.lat = currentLoc.coordinate.latitude
                userDetail?.lng = currentLoc.coordinate.longitude
                
                geocoder.reverseGeocodeLocation(currentLoc) { (placemarks, error) in
                    self.processResponse(withPlacemarks: placemarks, error: error)
                }
            }
            
//            print("Latitude: \(currentLoc.coordinate.latitude)")
//            print("Longitude: \(currentLoc.coordinate.longitude)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        let location = locations.last as! CLLocation
        print("Location: \(location)")
        userDetail?.currentLocation = location
        
        if userDetail?.currentLocation != nil
        {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
//        locManager.stopUpdatingLocation()
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View

        if let error = error
        {
            print("Unable to Reverse Geocode Location (\(error))")
        }
        else
        {
            if let placemarks = placemarks, let placemark = placemarks.first
            {
                userDetail?.currentAddress = placemark.compactAddress ?? ""
                userDetail?.locationName = placemark.name ?? ""
                userDetail?.country = placemark.currentCountry ?? ""
                defaults.set(userDetail?.currentAddress, forKey: "address")
                defaults.set(userDetail?.locationName, forKey: "locName")
                defaults.set(userDetail?.country, forKey: "country")
                tableView.reloadData()
            }
        }
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
        let AdDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AdDetailVC") as! AdDetailVC
        self.navigationController?.pushViewController(AdDetailVC, animated: true)
    }
    
    //MARK:- go to add detail controller
    func goToAddDetailVC(detail: AdsJSON) {
        let adDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AdDetailVC") as! AdDetailVC
        adDetailVC.adDetailDataObj = detail
        self.navigationController?.pushViewController(adDetailVC, animated: true)
    }
    
    //MARK:- Add to favourites
    func addToFavourites(ad_id: Int, favFlag: Bool)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            if !favFlag
            {
                let parameter: [String: Any] = ["ad_id": ad_id, "user_id": userDetail?.id ?? 0]
                self.makeAddFavourite(param: parameter as NSDictionary)
            }
            else
            {
                self.showToast(message: "This Ad is already in your favourites.")
            }
        }
    }
    
    //MARK:- go to category detail
    func goToCategoryDetail() {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- go to ad list
    func goToAdFilterListVC(cat_id: Int, catName: String) {
        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        adFilterListVC.categoryID = cat_id
        adFilterListVC.catName = catName
        self.navigationController?.pushViewController(adFilterListVC, animated: true)
    }
    
    @objc func actionHome() {
        appDelegate.moveToHome()
    }

    
    //MARK:- Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.searchBarNavigation.endEditing(true)
        searchBar.endEditing(true)
        self.view.endEditing(true)
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

            cell.numberOfColums = 3
            cell.categoryArray  = categoryArray
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
        }
        else if section == 1
        {
            let cell: AddsTableCell  = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell
            
            cell.locationBtnAction = { () in
                let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
                self.navigationController?.pushViewController(locationVC, animated: true)
            }
            if userDetail?.locationName != ""
            {
                cell.locBtn.setTitle(userDetail?.locationName, for: .normal)
            }
            
            cell.dataArray = latestAdsArray
            cell.delegate = self
            cell.reloadData()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = indexPath.section
        var totalHeight : CGFloat = 0
        var height: CGFloat = 0
          
        if section == 0
        {
            let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
            let totalRow = ceil(CGFloat(categoryArray.count + 1) / CollectionViewSettings.column)
            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing)
            height =  totalHeight - 30
        }
        else if section == 1
        {
            let itemHeight = CollectionViewSettings.getAdItemWidth(boundWidth: tableView.bounds.size.width)
            let totalRow = ceil(CGFloat(latestAdsArray.count) / 2)
            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing)
            height =  totalHeight + 350
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
                adDetailObj = AdDetailObject()
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
                let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
                self.navigationController?.pushViewController(messagesVC, animated: false)
            }
        }
    }
    
    //MARK:- API Call

    func homeData()
    {
        categoryArray.removeAll()
        latestAdsArray.removeAll()
        
        let parameter: [String: Any] = ["user_id" : self.defaults.integer(forKey: "userID")]
        
        AddsHandler.homeData(parameter: parameter as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            
            if successResponse.success {
                
                print(successResponse.categories)
                
                categoryArray = successResponse.categories
                self.latestAdsArray = successResponse.adsData
                
                if self.defaults.bool(forKey: "isLogin") == true
                {
                    userDetail?.id = self.defaults.integer(forKey: "userID")
                    userDetail?.displayName = self.defaults.string(forKey: "displayName")
                    userDetail?.userEmail = self.defaults.string(forKey: "userEmail")
//                    userDetail?.authToken = self.defaults.string(forKey: "authToken")!
                }
                
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
    
    @objc func nokri_showNavController1(){
        
        let scrollPoint = CGPoint(x: 0, y: 0)
        self.tableView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    @objc func showAd(){
        currentVc = self
    }
    
    @objc func showAd2(){
        currentVc = self
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
    
    //MARK:- Make Add Favourites
    
    func makeAddFavourite(param: NSDictionary) {
        self.showLoader()
        AddsHandler.makeAddFavourite(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                var currentIndex = 0

                for var post in self.latestAdsArray
                {
                    if post.id == (param.value(forKey: "ad_id") as! Int)
                    {
                        post.isFavorite = true
                        self.latestAdsArray[currentIndex] = post
                        break
                    }

                    currentIndex += 1
                }
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
}

extension CLPlacemark {

    var compactAddress: String? {
        if let name = name {
            var result = name

//            if let street = thoroughfare {
//                result += ", \(street)"
//            }

//            if let city = locality {
//                result += ", \(city)"
//            }

            if let country = country {
//                userDetail?.country = country
                result += ", \(country)"
            }

            return result
        }

        return nil
    }
    
    var currentCountry: String?
    {
        if let country = country
        {
            return country
        }

        return nil
    }
}

class DynamicHeightCollectionView: UICollectionView
{
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize
    {
        return collectionViewLayout.collectionViewContentSize
    }
}
