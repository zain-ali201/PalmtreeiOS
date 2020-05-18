//
//  RejectedAds.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Cosmos
import IQKeyboardManagerSwift

class RejectedAds: UIViewController, NVActivityIndicatorViewable,UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {

    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: RejectedAdsCell.className, bundle: nil), forCellWithReuseIdentifier: RejectedAdsCell.className)
        }
    }
    
    
    @IBOutlet weak var lblExpireAds: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var lblLoginTime: UILabel!
    @IBOutlet weak var oltEdit: UIButton!
    @IBOutlet weak var rateBar: CosmosView!
    @IBOutlet weak var lblSold: UILabel!
    @IBOutlet weak var lblInactive: UILabel!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var oltPost: UIButton!{
        didSet {
            oltPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    
    
    //MARK:- Properties
    var dataArray = [RejectedAdsAdd]()
    var userProfile: RejectedAdsProfile?
    var currentPage = 0
    var maximumPage = 0
    let defaults = UserDefaults.standard
    var noAdTitle = ""
    var textEdit = ""
    
    
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
       
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage()
        navigationButtons()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adforest_rejectedAds()
    }
    
    //MARK: - Custom
    

    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func populateData() {
        if userProfile != nil {
            let objData = userProfile
            
            if let imgUrl = URL(string: objData?.profileImg ?? "") {
                imgProfile.setImage(from: imgUrl)
            }
            
            if let name = objData?.displayName {
                lblName.text = name
            }
            
            if let loginTime = objData?.lastLogin {
                lblLoginTime.text = loginTime
            }
            
            if let editTitle = objData?.editText {
                oltEdit.setTitle(editTitle, for: .normal)
            }
            
            if let verify = objData?.verifyButon.text {
                lblVerified.text = verify
            }
            if let verifyColor = objData?.verifyButon.color {
                lblVerified.backgroundColor = Constants.hexStringToUIColor(hex: verifyColor)
            }
            
            if let soldAds = objData?.adsSold {
                lblSold.text = soldAds
            }
            if let allAds = objData?.adsTotal {
                lblAll.text = allAds
            }
            if let inactiveAds = objData?.adsInactive {
                lblInactive.text = inactiveAds
            }
            if let expAds = objData?.adsExpired {
                self.lblExpireAds.text = expAds
            }
            
            if let rateBar = objData?.rateBar.number {
                self.rateBar.settings.updateOnTouch = false
                self.rateBar.settings.fillMode = .precise
                self.rateBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
                self.rateBar.rating = Double(rateBar)!
            }
            if let avgRating = objData?.rateBar.text {
                rateBar.text = avgRating
            }
        }
    }
    
    //MARK:- IBActions
    @IBAction func actionEdit(_ sender: UIButton) {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: EditProfileController.className) as! EditProfileController
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
    
    //MARK:- API Calls
    func adforest_rejectedAds() {
        showLoader()
        AddsHandler.rejectedAds(success: {[unowned self] (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                if let pageTitle = successResponse.data.pageTitle {
                    self.title = pageTitle
                }
                if let edit = successResponse.data.text.editText {
                    self.textEdit = edit
                }
                self.noAdTitle = successResponse.message
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.ads
                self.userProfile = successResponse.data.profile
                self.populateData()
                self.collectionView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[unowned self] (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adforest_moreAds(parameter: [String:Any]) {
        showLoader()
        AddsHandler.moreRejectedAds(params: parameter, success: {[unowned self] (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.ads)
                self.collectionView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[unowned self] (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}

extension RejectedAds: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataArray.count == 0 {
           collectionView.setEmptyMessage(noAdTitle)
        } else {
            collectionView.restore()
        }
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RejectedAdsCell.className, for: indexPath) as! RejectedAdsCell
        let objData = dataArray[indexPath.row]
        if let imgUrl = URL(string: objData.adImages[0].thumb) {
            cell.imgIcon.setImage(from: imgUrl)
        }
        
        if let title = objData.adTitle {
            cell.lblName.text = title
        }
        
        if let desc = objData.adPrice.priceType {
            cell.lblDescription.text = desc
        }
        cell.oltEdit.setTitle(textEdit, for: .normal)
        cell.btnEdit = {[unowned self] () in
            let editAdVC = self.storyboard?.instantiateViewController(withIdentifier: AadPostController.className) as! AadPostController
            editAdVC.isFromEditAd = true
            editAdVC.ad_id = objData.adId
            self.navigationController?.pushViewController(editAdVC, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addDetailVC = storyboard?.instantiateViewController(withIdentifier: AddDetailController.className) as! AddDetailController
        addDetailVC.ad_id = dataArray[indexPath.row].adId
        addDetailVC.isFromRejectedAd = true
        navigationController?.pushViewController(addDetailVC, animated: true)
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
            adforest_moreAds(parameter: param)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Constants.isiPadDevice {
            let width = collectionView.bounds.width/3.0
            return CGSize(width: width, height: 250)
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
