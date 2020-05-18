//
//  CategoryController.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import DropDown
import Firebase
import IQKeyboardManagerSwift

class CategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, CategoryFeatureDelegate, CustomHeaderParameterDelegate, UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate  {
  
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    //MARK:- Properties
    var locId = 0
    var categoryID = 0
    var isFromLocation = false
    
    var dataArray = [CategoryAd]()
    var categotyAdArray = [CategoryAd]()
    
    var currentPage = 0
    var maximumPage = 0
    
    var featureAddTitle = ""
    var addcategoryTitle = ""
    let defaults = UserDefaults.standard
    var orderArray = [String]()
    var orderKeysArray = [String]()
    var orderName = ""
    
    var isFromAdvanceSearch = false
    var isFromNearBySearch = false
    var isFromTextSearch = false
    var searchText = ""
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var nearByDistance: CGFloat = 0.0
    
    
    var nearByTitle = ""
    //var latitude: Double = 0
    //var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()

    var barButtonItems = [UIBarButtonItem]()
    var topBarObj :CategoryTopBar!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showBackButton()
        self.googleAnalytics(controllerName: "Category Controller")
        self.adMob()
        navigationButtons()
        if isFromAdvanceSearch == true {
        self.orderName = topBarObj.sortArrKey.value

        for ob in topBarObj.sortArr{
            self.orderArray.append(ob.value)
            self.orderKeysArray.append(ob.key)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if isFromAdvanceSearch {
            self.dataArray = AddsHandler.sharedInstance.objCategoryArray
            self.categotyAdArray = AddsHandler.sharedInstance.objCategotyAdArray
            print(self.categotyAdArray)
            self.tableView.reloadData()
        }
        else if isFromNearBySearch {
            let param: [String: Any] = ["nearby_latitude": latitude, "nearby_longitude": longitude, "nearby_distance": nearByDistance, "page_number": 1]
            print(param)
            self.adForest_categoryData(param: param as NSDictionary)
        } else if isFromTextSearch {
            let param: [String: Any] = ["ad_title": searchText ,"ad_country":locId ,"page_number": 1]
            print(param)
            UserDefaults.standard.set(0, forKey: "locId")
            self.adForest_categoryData(param: param as NSDictionary)
        } else if isFromLocation {
            let param: [String: Any] = ["ad_country" : categoryID]
            print(param)
            self.adForest_categoryData(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["ad_cats1" : categoryID, "page_number": 1]
            print(param)
            self.adForest_categoryData(param: param as NSDictionary)
        }
    }
    
    //MARK: - Custom
    func showLoader() {
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
                        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
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
    
    func paramData(param: NSDictionary) {
        self.adForest_categoryData(param: param)
    }
    
    func goToDetailController(id: Int) {
        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        addDetailVC.ad_id = id
        self.navigationController?.pushViewController(addDetailVC, animated: true)
    }
    
    //MARK:- Table View Delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell: CategoryFeatureCell =  tableView.dequeueReusableCell(withIdentifier: "CategoryFeatureCell", for: indexPath) as! CategoryFeatureCell
            cell.dataArray = self.categotyAdArray
            cell.delegate = self
            cell.reloadData()
            return cell
        case 1:
            let cell: CategoryCell =  tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let objData = dataArray[indexPath.row]
            
            for image in objData.images {
                if let imgUrl = URL(string: image.thumb) {
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                }
            }
            if let title = objData.adTitle {
                cell.lblName.text = title
            }
            if let location = objData.location.address {
                cell.lblLocation.text = location
            }
            if let price = objData.adPrice.price {
                cell.lblPrice.text = price
            }
            
            if let catName = objData.adCatsName {
                cell.lblPath.text = catName
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 1 {
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
            addDetailVC.ad_id = dataArray[indexPath.row].adId
            self.navigationController?.pushViewController(addDetailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["ad_cats1" : categoryID, "page_number": currentPage]
            print(param)
            self.adForest_loadMoreData(param: param as NSDictionary)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        switch section {
        case 0:
            if AddsHandler.sharedInstance.isShowFeatureOnCategory {
                return 240
            } else if isFromAdvanceSearch {
                if AddsHandler.sharedInstance.objCategotyAdArray.count == 0 {
                    return 0
                } else {
                    return 240
                }
            } else {
                return 0
            }
        case 1:
            return 110
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if AddsHandler.sharedInstance.isShowFeatureOnCategory {
                return 50
            }else {
                return 0
            }
        case 1:
                return 50
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("CustomHeader", owner: self, options: nil)?.first as! CustomHeader
        switch section {
        case 0:
            headerView.imgIcon.isHidden = true
            headerView.oltOrder.isHidden = true
            headerView.lblTotalAds.text = self.featureAddTitle
            return headerView
        case 1:
            if isFromTextSearch {
                headerView.imgIcon.isHidden = true
//                headerView.oltOrder.isHidden = true
                headerView.oltOrder.backgroundColor = UIColor.clear
                headerView.lblTotalAds.text = self.addcategoryTitle
                print(isFromTextSearch)
            }else{
                headerView.imgIcon.isHidden = false
                headerView.oltOrder.isHidden = false
                headerView.lblTotalAds.text = self.addcategoryTitle
                headerView.oltOrder.setTitle(orderName, for: .normal)
                headerView.btnSort = { () in
                headerView.categoryID = self.categoryID
                headerView.orderArray = self.orderArray
                headerView.orderKeysArray = self.orderKeysArray
                headerView.delegate = self
                headerView.orderDropDown()
                headerView.arrangeDropDown.show()
                }
            }
            return headerView
        default:
            break
        }
        return UIView()
    }
    
    //MARK:- API Call
    func adForest_categoryData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.categoryData(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.extra.title
                self.featureAddTitle = successResponse.data.featuredAds.text
                self.addcategoryTitle = successResponse.topbar.countAds
                self.currentPage = successResponse.pagination.currentPage
                self.maximumPage = successResponse.pagination.maxNumPages
                
                //set drop down data
                self.orderName = successResponse.topbar.sortArrKey.value
                self.orderArray = []
                for order in successResponse.topbar.sortArr {
                    self.orderKeysArray.append(order.key)
                    self.orderArray.append(order.value)
                }
                AddsHandler.sharedInstance.objCategory = successResponse
                AddsHandler.sharedInstance.isShowFeatureOnCategory = successResponse.extra.isShowFeatured
                self.dataArray = successResponse.data.ads
                self.categotyAdArray = successResponse.data.featuredAds.ads
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
    
    func adForest_loadMoreData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.categoryData(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objCategory = successResponse
                AddsHandler.sharedInstance.isShowFeatureOnCategory = successResponse.extra.isShowFeatured
                self.dataArray.append(contentsOf: successResponse.data.ads)
                //self.categotyAdArray.append(contentsOf: successResponse.data.featuredAds.ads)
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
