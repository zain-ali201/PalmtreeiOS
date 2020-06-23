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
    
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Properties
   
    var dataArray = [MyAdsAd]()
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
//        refreshControl.tintColor = UIColor.red
        
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
        
        checkLogin()
        
        if defaults.string(forKey: "languageCode") == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            changeMenuButtons()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func checkLogin()
    {
        if UserDefaults.standard.bool(forKey: "isLogin") == false
        {
            signinView.alpha = 1
            infoView.alpha = 0
            lampView.alpha = 1
            count = 0
        }
        else
        {
//            self.getAddsData()
            signinView.alpha = 0
            infoView.alpha = 1
            lampView.alpha = 0
            count = 6
            tblView.reloadData()
        }
    }
    
    func changeMenuButtons()
    {
        btnHome.setImage(UIImage(named: "home_active_" + (defaults.string(forKey: "languageCode") ?? "en")), for: .normal)
        btnPalmtree.setImage(UIImage(named: "mypalmtree_" + (defaults.string(forKey: "languageCode") ?? "en")), for: .normal)
        btnPost.setImage(UIImage(named: "post_" + (defaults.string(forKey: "languageCode") ?? "en")), for: .normal)
        btnWishlist.setImage(UIImage(named: "wishlist_" + (defaults.string(forKey: "languageCode") ?? "en")), for: .normal)
        btnMessages.setImage(UIImage(named: "messages_" + (defaults.string(forKey: "languageCode") ?? "en")), for: .normal)
        
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
                let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
                self.navigationController?.pushViewController(messagesVC, animated: false)
            }
        }
    }
    
    //MARK:- Collection View Delegate Methods
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//       return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        if dataArray.count == 0 {
////            lampView.alpha = 1
////        } else {
////            lampView.alpha = 0
////            collectionView.restore()
////        }
////        return dataArray.count
//        return count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: MyAdsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyAdsCollectionCell", for: indexPath) as! MyAdsCollectionCell
//
////        let objData = dataArray[indexPath.row]
////
////        for images in objData.adImages {
////            if let imgUrl = URL(string: images.thumb) {
////                cell.imgPicture.setImage(from: imgUrl)
////            }
////        }
////
////        if let userName = objData.adTitle {
////            cell.lblName.text = userName
////        }
////        if let price = objData.adPrice.price {
////            cell.lblPrice.text = price
////        }
////
////        if let addStatus = objData.adStatus.statusText {
////            cell.lblAddType.text = addStatus
////            //set drop down button status
////            cell.buttonAddType.setTitle(addStatus, for: .normal)
////        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: AddDetailController.className) as! AddDetailController
////        addDetailVC.ad_id = dataArray[indexPath.row].adId
////        self.navigationController?.pushViewController(addDetailVC, animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView.isDragging {
//            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
//            UIView.animate(withDuration: 0.3, animations: {
//                cell.transform = CGAffineTransform.identity
//            })
//        }
////        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
////            currentPage = currentPage + 1
////            let param: [String: Any] = ["page_number": currentPage]
////            print(param)
////            self.loadMoreData(param: param as NSDictionary)
////        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: screenWidth - 12, height: 190)
//    }
//
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
    
    //MARK:- TableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        self.navigationController?.pushViewController(productDetailVC, animated: true)
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
        AddsHandler.myAds(success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.noAddTitle = successResponse.message
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                
                AddsHandler.sharedInstance.objMyAds = successResponse.data
                self.dataArray = successResponse.data.ads
                
//                self.collectionView.reloadData()
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
        AddsHandler.moreMyAdsData(param: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                AddsHandler.sharedInstance.objMyAds = successResponse.data
                self.dataArray.append(contentsOf: successResponse.data.ads)
                
                self.tblView.reloadData()
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
