//
//  MyAdsController.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MyAdsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NVActivityIndicatorViewable{

    //MARK:- Outlets
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var lampView: UIImageView!
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmailverified: UILabel!
    @IBOutlet weak var lblJoining: UILabel!
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var signinBtn: UIButton!
    
    @IBOutlet weak var tblView: UITableView!{
        didSet {
            tblView.addSubview(refreshControl)
        }
    }
    
    //MARK:- Properties
   
    var dataArray = [AdsJSON]()
    var profileDataArray = [ProfileDetailsData]()
    
    var ad_id = 0
    var noAddTitle = ""
    var currentPage = 0
    var maximumPage = 0
    
    var count = 0
    
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
    
    //MenuButtons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPalmtree: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "My Ads Controller")
        myAdsVC = self
        
        imgPicture.layer.cornerRadius = 34
        imgPicture.layer.masksToBounds = true
        
        lblName.text = userDetail?.displayName ?? ""
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            changeMenuButtons()
            
            lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblJoining.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmailverified.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            signinBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkLogin()
    {
        if UserDefaults.standard.bool(forKey: "isLogin") == true
        {
            tblView.alpha = 1
            self.getAddsData()
            signinView.alpha = 0
            infoView.alpha = 1
            lampView.alpha = 0
            tblView.reloadData()
            
            if let joining = userDetail?.joining
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = formatter.date(from: joining)
                formatter.dateFormat = "yyyy"
                let year = formatter.string(from: date!)
                
                if languageCode == "ar"
                {
                    lblJoining.text =   "\(year) مسجل كعضو منذ"
                }
                else
                {
                    lblJoining.text =  "Member since \(year)"
                }
            }
        }
        else
        {
            tblView.alpha = 0
            signinView.alpha = 1
            infoView.alpha = 0
            lampView.alpha = 1
        }
    }
    
    func changeMenuButtons()
    {
        btnHome.setImage(UIImage(named: "home_" + languageCode ), for: .normal)
        btnPalmtree.setImage(UIImage(named: "mypalmtree_active_" + languageCode), for: .normal)
        btnPost.setImage(UIImage(named: "post_" + languageCode), for: .normal)
        btnWishlist.setImage(UIImage(named: "wishlist_" + languageCode), for: .normal)
        btnMessages.setImage(UIImage(named: "messages_" + languageCode ), for: .normal)
        
        btnHome.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPalmtree.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnWishlist.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnMessages.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
    
    //MARK: - Custom

    @objc func refreshTableView() {
       getAddsData()
    }
    
    func showLoader()
    {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- IBActions
    @IBAction func settingsBtnAction(_ sender: Any)
    {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func signinBtnAction(_ sender: Any)
    {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navController = UINavigationController(rootViewController: loginVC)
        self.present(navController, animated:true, completion: nil)
    }
    
    @IBAction func menuBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            self.navigationController?.popToViewController(homeVC, animated: false)
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

    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        let objData = dataArray[indexPath.row]

        if objData.images.count > 0
        {
            if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, objData.images[0].url.encodeUrl())) {
                cell.imgPicture.setImage(from: imgUrl)
            }
        }

        if let userName = objData.title {
            cell.lblName.text = userName
        }
        if let price = objData.price {
            cell.lblPrice.text = price
        }
        
        if let address = objData.address {
            cell.btnLocation.setTitle(address, for: .normal)
        }
        
        if let date = objData.createdAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.date(from: date)
            
            cell.lblDate.text = timeAgoSinceShort(date!)
        }
        
        cell.crossAction = { () in
            let alert = UIAlertController(title: "Palmtree", message: "Are you sure you want to remove your ad?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes", style: .default, handler: { (okAction) in
                let parameter : [String: Any] = ["post_id": objData.id]
                print(parameter)
                self.deleteAd(param: parameter as NSDictionary)
            })
            let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.presentVC(alert)
        }
        
        if objData.isFeatured
        {
            cell.lblPromotion.alpha = 1
            cell.promoteBtn.alpha = 0
        }
        else
        {
            cell.lblPromotion.alpha = 0
            cell.promoteBtn.alpha = 1
            cell.promoteAdAction = { () in
                adDetailObj = AdDetailObject()
                adDetailObj.adId = objData.id
                adDetailObj.adTitle = objData.title
                adDetailObj.adDesc = objData.description
                adDetailObj.adPrice = objData.price
                adDetailObj.location.address = objData.address
                adDetailObj.adImages = objData.images
                adDetailObj.location.address = objData.address
                adDetailObj.location.country = objData.country
                
                let featuredVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedVC") as! FeaturedVC
                featuredVC.fromVC = "myads"
                self.navigationController?.pushViewController(featuredVC, animated: true)
            }
        }
        
        cell.editAdAction = { () in
            adDetailObj = AdDetailObject()
            adDetailObj.adId = objData.id
            adDetailObj.adTitle = objData.title
            adDetailObj.adDesc = objData.description
            adDetailObj.location.address = objData.address
            adDetailObj.adPrice = objData.price
            adDetailObj.priceType = objData.price_type
            adDetailObj.adDate = objData.createdAt
            adDetailObj.phone = objData.phone
            adDetailObj.whatsapp = objData.whatsapp
            adDetailObj.location.country = objData.country
            
            if objData.catParent != nil
            {
                adDetailObj.adSubCategory = objData.catName
                adDetailObj.subcatID = objData.catID
                adDetailObj.adCategory = objData.catParent
                adDetailObj.catID = objData.catParentID
            }
            else
            {
                adDetailObj.adCategory = objData.catName
                adDetailObj.catID = objData.catID
            }
            
            adDetailObj.adImages = objData.images
            
            let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostVC") as! AdPostVC
            adPostVC.fromVC = "myads"
            let navController = UINavigationController(rootViewController: adPostVC)
            navController.navigationBar.isHidden = true
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated:true, completion: nil)
        }

        if languageCode == "ar"
        {
            cell.lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.btnLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblProcess.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblPromotion.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.editBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblDate.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            cell.lblName.textAlignment = .right
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = dataArray[indexPath.row]
        let adDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AdDetailVC") as! AdDetailVC
        adDetailVC.adDetailDataObj = objData
        self.navigationController?.pushViewController(adDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    //MARK:- API Calls
    //Ads Data
    func getAddsData() {
        self.showLoader()
        
        let parameters: [String: Any] = ["user_id": String(format: "%d", userDetail?.id ?? 0)]
        
        AddsHandler.myAds(parameter: parameters as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
//                self.noAddTitle = successResponse.message
//                self.currentPage = successResponse.data.pagination.currentPage
//                self.maximumPage = successResponse.data.pagination.maxNumPages
                
                self.dataArray = successResponse.data
                
                self.tblView.reloadData()
                
                if self.dataArray.count == 0
                {
                    self.lampView.alpha = 1
                }
            }
            else
            {
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
        AddsHandler.moreMyAdsData(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success
            {
                self.dataArray.append(contentsOf: successResponse.data)
                self.tblView.reloadData()
            }
            else
            {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func deleteAd(param: NSDictionary)
    {
        self.showLoader()
        AddsHandler.deleteAdd(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.getAddsData()
                    self.tblView.reloadData()
                })
                self.presentVC(alert)
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
