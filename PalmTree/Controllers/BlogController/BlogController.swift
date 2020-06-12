//
//  BlogController.swift
//  PalmTree
//
//  Created by SprintSols on 3/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class BlogController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable,UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            let nib = UINib(nibName: "BlogCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "BlogCell")
        }
    }
    
    @IBOutlet weak var oltAdPost: UIButton!{
        didSet {
            oltAdPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltAdPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
    }
    
    
    //MARK:- Properties
    var dataArray = [BlogPost]()
    var currentPage = 0
    var maximumPage = 0
    let defaults = UserDefaults.standard
    var isFromHomeBlog = false
    
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
        self.googleAnalytics(controllerName: "Blog Controller")
        self.adMob()
        if defaults.bool(forKey: "isRtl") {
            if isFromHomeBlog {
                self.showBackButton()
            }else {
                 self.addRightBarButtonWithImage()
            }
        } else {
            if isFromHomeBlog {
                self.showBackButton()
            } else {
                self.addLeftBarButtonWithImage()
            }
        }
        self.blogData()
        if defaults.bool(forKey: "isGuest") {
            self.oltAdPost.isHidden = true
        }
        navigationButtons()
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
                    SwiftyAd.shared.setup(withBannerID: "", interstitialID: (objData?.interstitalId)!, rewardedVideoID: "")
                    SwiftyAd.shared.showInterstitial(from: self)
                }
            }
        }
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BlogCell = tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath) as! BlogCell
        let objData = dataArray[indexPath.row]
        
        if objData.hasImage {
            if let imgUrl = URL(string: objData.image) {
                cell.imgPicture.setImage(from: imgUrl)
            }
        }
        else if objData.hasImage == false {
            cell.imgPicture.isHidden = true
        }
        if let postTitle = objData.title {
            cell.lblName.text = postTitle
        }
        let comments = objData.comments
        
        if comments == nil {
            cell.lblRating.text = "0"
        }
        else {
            cell.lblRating.text = comments
        }

        if let date = objData.date {
            cell.lblDate.text = date
        }
        if let readMoreText = objData.readMore {
            cell.lblReadMore.text = readMoreText
        }
        if let mainColor = defaults.string(forKey: "mainColor") {
            cell.lblReadMore.textColor = Constants.hexStringToUIColor(hex: mainColor)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let blogDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailController") as! BlogDetailController
        blogDetailVC.post_id = dataArray[indexPath.row].postId
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
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
            let param: [String: Any] = ["page_number": currentPage]
            self.loadMoreData(param: param as NSDictionary)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let objData = dataArray[indexPath.row]
        var height: CGFloat = 0.0
        if objData.hasImage {
            height = 230
        }
        else if objData.hasImage == false {
            height = 70
        }
        return height
    }
    
    //MARK:- IBActions
    @IBAction func actionAdPost(_ sender: Any) {
      
        let notVerifyMsg = UserDefaults.standard.string(forKey: "not_Verified")
        let can = UserDefaults.standard.bool(forKey: "can")
        
        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
            
            var msgLogin = ""
            
            if let msg = self.defaults.string(forKey: "notLogin") {
                msgLogin = msg
            }
            
            let alert = Constants.showBasicAlert(message: msgLogin)
            self.presentVC(alert)
            
        }else if can == false{
            
            
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
        else{
            let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
            self.navigationController?.pushViewController(adPostVC, animated: true)
        }
        
    }
    //MARK:- API Call
    
    func blogData() {
        self.showLoader()
        UserHandler.blogData(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
//                self.title = successResponse.extra.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.post
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
    
    //more blog data
    
    func loadMoreData(param: NSDictionary) {
        self.showLoader()
        UserHandler.moreBlogData(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray.append(contentsOf: successResponse.data.post)
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
