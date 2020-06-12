//
//  InactiveAdsController.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Cosmos
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class InactiveAdsController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NVActivityIndicatorViewable,UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {

    //MARK:- Outlets
    
    @IBOutlet weak var scrollBar: UIScrollView! {
        didSet {
            scrollBar.delegate = self
            scrollBar.isScrollEnabled = true
            scrollBar.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var containerViewProfile: UIView! {
        didSet {
            containerViewProfile.addShadowToView()
            collectionView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblLastLogin: UILabel!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var buttonEditProfile: UIButton!
    @IBOutlet weak var ratingBar: CosmosView!
    @IBOutlet weak var containerViewAdds: UIView!
    @IBOutlet weak var lblSoldAds: UILabel!
    @IBOutlet weak var lblAllAds: UILabel!
    @IBOutlet weak var lblinactiveAds: UILabel!
    
    @IBOutlet weak var lblExpireAds: UILabel!
    @IBOutlet weak var lblWaitingApproval: UILabel!
    @IBOutlet weak var imgApproval: UIImageView!
    @IBOutlet weak var containerViewAddApproval: UIView! {
        didSet {
            containerViewAddApproval.layer.cornerRadius = 5
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsVerticalScrollIndicator = false
            collectionView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var oltAdPost: UIButton! {
        didSet {
            oltAdPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltAdPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    
    //MARK:- Properties
    var dataArray = [MyAdsAd]()
    var noAddTitle = ""
    let defaults = UserDefaults.standard
    var currentPage = 0
    var maximumPage = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
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
        self.adMob()
        self.inactiveAdsData()
        self.addLeftBarButtonWithImage()
        self.googleAnalytics(controllerName: "Inactive Ads Controller")
        if defaults.bool(forKey: "isGuest") {
            self.oltAdPost.isHidden = true
        }
       // self.inactiveAdsData()
        navigationButtons()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         self.inactiveAdsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
//        if AddsHandler.sharedInstance.objInactiveAds == nil{
//             self.inactiveAdsData()
//        }
      
    }
    
    //MARK: - Custom
    
    @objc func refreshTableView() {
        inactiveAdsData()
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func populateData() {
        if AddsHandler.sharedInstance.objInactiveAds != nil {
            let objData = AddsHandler.sharedInstance.objInactiveAds
            
            self.title = objData?.pageTitle
            if let imgUrl = URL(string: (objData?.profile.profileImg)!) {
                self.imgPicture.setImage(from: imgUrl)
            }
            if let userName = objData?.profile.displayName {
                self.lblName.text = userName
            }
            if let isAddVerified = objData?.profile.verifyButon.text {
                self.lblUserType.text = isAddVerified
            }
            if let isAddVerifiedbackgroundColor = objData?.profile.verifyButon.color {
                self.lblUserType.backgroundColor = Constants.hexStringToUIColor(hex: isAddVerifiedbackgroundColor)
            }
            if let lastLoginTime = objData?.profile.lastLogin {
                self.lblLastLogin.text = lastLoginTime
            }
            if let editProfileText = objData?.profile.editText {
                self.buttonEditProfile.setTitle(editProfileText, for: .normal)
            }
            
            if let rateBar = objData?.profile.rateBar.number {
                self.ratingBar.settings.updateOnTouch = false
                self.ratingBar.settings.fillMode = .precise
                self.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: "#ffcc00")
                self.ratingBar.rating = Double(rateBar)!
            }
            if let avgRating = objData?.profile.rateBar.text {
                ratingBar.text = avgRating
            }
            
            if let soldAds = objData?.profile.adsSold {
                self.lblSoldAds.text = soldAds
            }
            if let allAds = objData?.profile.adsTotal {
                self.lblAllAds.text = allAds
            }
            if let inactiveAds = objData?.profile.adsInactive {
                self.lblinactiveAds.text = inactiveAds
            }
            if let expAds = objData?.profile.adsExpired {
                self.lblExpireAds.text = expAds
            }
            if let waitinApproval = objData?.notification {
                self.lblWaitingApproval.text = waitinApproval
            }
        }
            
        else {
        }
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
                        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
                        self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 70).isActive = true
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

    
    //MARK:- Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            collectionView.setEmptyMessage(noAddTitle)
        } else {
            collectionView.restore()
        }
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InactiveCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: InactiveCollectionCell.className, for: indexPath) as! InactiveCollectionCell
        let objData = dataArray[indexPath.row]
        for images in objData.adImages {
            if let imgUrl = URL(string: images.thumb) {
                cell.imgPicture.setImage(from: imgUrl)
            }
        }
        
        if let addTitle = objData.adTitle {
            cell.lblName.text = addTitle
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: AddDetailController.className) as! AddDetailController
        addDetailVC.ad_id = self.dataArray[indexPath.row].adId
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            self.loadMoreData(param: param as NSDictionary)
        }
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

    //MARK:- IBActions
    @IBAction func actionEditProfile(_ sender: Any) {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
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
    
    //Inactive Ads Data
    func inactiveAdsData() {
        self.showLoader()
        AddsHandler.inactiveAds(success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.noAddTitle = successResponse.message
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                AddsHandler.sharedInstance.objInactiveAds = successResponse.data
                self.dataArray = successResponse.data.ads
                self.populateData()
                self.collectionView.reloadData()
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
    
    func loadMoreData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.moreInactiveAdsdata(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                AddsHandler.sharedInstance.objInactiveAds = successResponse.data
                self.dataArray.append(contentsOf: successResponse.data.ads)
                self.populateData()
                self.collectionView.reloadData()
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
