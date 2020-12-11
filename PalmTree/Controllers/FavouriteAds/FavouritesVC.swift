//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FavouritesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NVActivityIndicatorViewable{

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var favTblView: UITableView!
    @IBOutlet weak var alertsTblView: UITableView!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    //MenuButtons
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnPalmtree: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnWishlist: UIButton!
    @IBOutlet weak var btnMessages: UIButton!
    
    @IBOutlet weak var norecordsView: UIView!
    @IBOutlet weak var lblText1: UILabel!
    @IBOutlet weak var lblText2: UILabel!
    @IBOutlet weak var listingBtn: UIButton!
    
    //MARK:- Properties
   
    var dataArray = [AdsJSON]()
    
    var ad_id = 0
    var noAddTitle = ""
    var currentPage = 0
    var maximumPage = 0
    
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
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Watchlist Controller")
        
        if languageCode == "ar"
        {
            changeMenuButtons()
        }
        
        self.favouriteAdsData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Custom

    @objc func refreshTableView() {
       favouriteAdsData()
    }
    
    func showLoader()
    {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func changeMenuButtons()
    {
        btnHome.setImage(UIImage(named: "home_" + languageCode ), for: .normal)
        btnPalmtree.setImage(UIImage(named: "mypalmtree_" + languageCode), for: .normal)
        btnPost.setImage(UIImage(named: "post_" + languageCode), for: .normal)
        btnWishlist.setImage(UIImage(named: "wishlist_active_" + languageCode), for: .normal)
        btnMessages.setImage(UIImage(named: "messages_" + languageCode ), for: .normal)
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any)
    {
        let adFilterListVC = self.storyboard?.instantiateViewController(withIdentifier: "AdFilterListVC") as! AdFilterListVC
        self.navigationController?.pushViewController(adFilterListVC, animated: true)
    }
    
    @IBAction func clickBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            favTblView.alpha = 1
            alertsTblView.alpha = 0
            self.leading.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            favBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            searchBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
        }
        else
        {
            favTblView.alpha = 0
            alertsTblView.alpha = 1
            leading.constant = screenWidth/2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            searchBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            favBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func menuBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            self.navigationController?.popToViewController(homeVC, animated: false)
        }
        else if button.tag == 1002
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
        
        if tableView.tag == 1001
        {
            return dataArray.count
        }
        else
        {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchAlertTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchAlertTableCell", for: indexPath) as! SearchAlertTableCell
        
        if tableView.tag == 1001
        {
            let objData = dataArray[indexPath.row]
            
            if objData.images.count > 0
            {
                if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, objData.images[0].url.encodeUrl())) {
                    print(imgUrl)
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
                
                
                let alert = UIAlertController(title: "Palmtree", message:NSLocalizedString(String(format: "fav_remove_%@",languageCode), comment: ""), preferredStyle: .alert)
                let okAction = UIAlertAction(title: NSLocalizedString(String(format: "yes_%@",languageCode), comment: ""), style: .default, handler: { (okAction) in
                    let parameter: [String: Any] = ["ad_id": objData.id ?? 0, "user_id" : userDetail?.id ?? 0]
                    print(parameter)
                    self.removeFavourite(param: parameter as NSDictionary)
                })
                let cancelAction = UIAlertAction(title: NSLocalizedString(String(format: "no_%@",languageCode), comment: ""), style: .default, handler: nil)
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.presentVC(alert)
            }
            
            cell.locationAction = { () in
                
            }
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
    
    //Get Favourite Ads Data
    func favouriteAdsData() {
        self.showLoader()
        
        let parameters: [String: Any] = ["id": String(format: "%d", userDetail?.id ?? 0)]
        
        AddsHandler.favouriteAds(parameter: parameters as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.noAddTitle = successResponse.message
//                self.currentPage = successResponse.data.pagination.currentPage
//                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data
                
                if self.dataArray.count == 0
                {
                    self.norecordsView.alpha = 1
                }
                
                self.favTblView.reloadData()
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
    
    //remove favourite
    func removeFavourite(param: NSDictionary) {
        self.showLoader()
        AddsHandler.removeFavAdd(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success
            {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.favouriteAdsData()
                    self.favTblView.reloadData()
                })
                self.presentVC(alert)
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
