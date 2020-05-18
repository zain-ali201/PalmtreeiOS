//
//  BlogDetailController.swift
//  PalmTree
//
//  Created by SprintSols on 3/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class BlogDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UIWebViewDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            
            let nib = UINib(nibName: "BlogDetailCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "BlogDetailCell")
            let nibWebView = UINib(nibName: "WebViewCell", bundle: nil)
            tableView.register(nibWebView, forCellReuseIdentifier: "WebViewCell")
            
            let replyNib = UINib(nibName: "ReplyCell", bundle: nil)
            tableView.register(replyNib, forCellReuseIdentifier: "ReplyCell")
            let commentNib = UINib(nibName: "CommentCell", bundle: nil)
            tableView.register(commentNib, forCellReuseIdentifier: "CommentCell")
            
            let ratingNib = UINib(nibName: "AdRatingCell", bundle: nil)
            tableView.register(ratingNib, forCellReuseIdentifier: "AdRatingCell")
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
    var post_id = 0
    let defaults = UserDefaults.standard
    var dataArray = [BlogDetailData]()
    var commentArray = [BlogDetailComment]()
    var replyArray = [BlogDetailReply]()
    var contentHeight : [CGFloat] = [0.0, 0.0]
    var webViewHeight: CGFloat = 0.0
  
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
        self.showBackButton()
        self.adMob()
        self.googleAnalytics(controllerName: "Blog Detail Controller")
        let param: [String: Any] = ["post_id": post_id]
        print(param)
        self.adForest_blogDetail(parameter: param as NSDictionary)
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
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 2 {
            if commentArray.isEmpty {
                return 0
            }
            else {
                return commentArray.count
            }
        }
        else if section == 3 {
            if replyArray.isEmpty {
                return  0
            }
            else {
                return replyArray.count
            }
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell: BlogDetailCell = tableView.dequeueReusableCell(withIdentifier: "BlogDetailCell", for: indexPath) as! BlogDetailCell
            let objData = dataArray[indexPath.row]
            if objData.post.hasImage {
                if let imgUrl = URL(string: objData.post.image) {
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                }
            }
            else if objData.post.hasImage == false {
                cell.imgPicture.isHidden = true
            }
            if let name = objData.post.title {
                cell.lblName.text = name
            }
            if let authorName = objData.post.authorName {
                cell.lblTitle.text = authorName
            }
            if let comments = objData.post.commentCount {
                cell.lblLikes.text = comments
            }
            if let date = objData.post.date {
                cell.lblDate.text = date
            }
            return cell
        }
        else if section == 1 {
            let cell: WebViewCell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell", for: indexPath) as! WebViewCell
            let objData = dataArray[indexPath.row]
            let htmlString = objData.post.desc
            let htmlHeight = contentHeight[indexPath.row]
            cell.webView.tag = indexPath.row
            cell.webView.delegate = self
            cell.webView.loadHTMLString(htmlString!, baseURL: nil)
            cell.webView.scrollView.isScrollEnabled = false
//            let stringSimple = htmlString?.html2String
//            print(stringSimple!)
//            let requestURL = URL(string:stringSimple!)
//            let request = URLRequest(url: requestURL!)
//            cell.webView.loadRequest(request)
            cell.webView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: htmlHeight)
            
            return cell
        }
        else if section == 2 {
            let cell: ReplyCell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
            let objData = commentArray[indexPath.row]
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name  = objData.commentAuthor {
                cell.lblName.text = name
            }
            if let msg = objData.commentContent {
                cell.lblReply.text = msg
            }
            if let date = objData.commentDate {
                cell.lblDate.text = date
            }
            
            if let rplyButtonText = objData.replyBtnText {
                cell.oltReply.setTitle(rplyButtonText, for: .normal)
                cell.oltReply.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            
            cell.ratingBar.isHidden = true
            cell.imgDate.translatesAutoresizingMaskIntoConstraints = false
            cell.imgDate.leftAnchor.constraint(equalTo: cell.imgProfile.rightAnchor, constant: 8).isActive = true
            
            if defaults.bool(forKey: "isGuest") {
                cell.oltReply.isHidden = true
            }
            else {
                cell.oltReply.isHidden = false
                if objData.canReply {
                    cell.oltReply.isHidden = false
                    cell.btnReplyAction = { () in
                        let commentVC = self.storyboard?.instantiateViewController(withIdentifier: "ReplyCommentController") as! ReplyCommentController
                        commentVC.modalPresentationStyle = .overCurrentContext
                        commentVC.modalTransitionStyle = .flipHorizontal
                        commentVC.isFromReplyComment = true
                        commentVC.objBlog = UserHandler.sharedInstance.objBlog
                        commentVC.comment_id = objData.commentId
                        self.presentVC(commentVC)
                    }
                } else {
                    cell.oltReply.isHidden = true
                }
            }
            return cell
        }
            
        else if section == 3 {
            let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            let objData = replyArray[indexPath.row]
            
            if let name = objData.commentAuthor {
                cell.lblName.text = name
            }
            if let date = objData.commentDate {
                cell.lblDate.text = date
            }
            if let msg = objData.commentContent {
                cell.lblReply.text = msg
            }
            if let imgUrl = URL(string: objData.img) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
            
            return cell
        }
        else if section == 4 {
            if defaults.bool(forKey: "isGuest") {
                
            }
            else {
                let cell: AdRatingCell = tableView.dequeueReusableCell(withIdentifier: "AdRatingCell", for: indexPath) as! AdRatingCell
                let objData = dataArray[indexPath.row]
                let data = UserHandler.sharedInstance.objBlog
                cell.ratingBar.isHidden = true
                if objData.post.commentStatus == "open" {
                    if objData.post.hasComment {
                        cell.lblTitle.text = ""
                    }
                    else {
                        if let commentMsg = objData.post.commentMesage {
                            cell.lblTitle.text = commentMsg
                            cell.lblTitle.textAlignment = .center
                        }
                    }
                    if let commentTitle = data?.extra.commentForm.title {
                        cell.lblPostComment.text = commentTitle
                    }
                    if let txtTitle = data?.extra.commentForm.textarea {
                        cell.txtComment.placeholder = txtTitle
                    }
                    if let btnTitle = data?.extra.commentForm.btnSubmit {
                        cell.oltSubmitRating.setTitle(btnTitle, for: .normal)
                    }
                    
                    cell.btnSubmitAction = { () in
                        guard let txtComment = cell.txtComment.text else {
                            return
                        }
                        if txtComment == "" {
                            cell.txtComment.shake(6, withDelta: 10, speed: 0.06)
                        }
                        else {
                            var postID = 0
                            if let id = objData.post.postId {
                                postID = id
                            }
                            let param: [String: Any] = ["comment_id": "", "post_id": postID, "message": txtComment]
                            print(param)
                            self.adForest_blogPostComment(param: param as NSDictionary)
                        }
                    }
                }
                    
                else if objData.post.commentStatus == "closed" {
                    if let commentMsg = objData.post.commentMesage {
                        cell.lblTitle.text = commentMsg
                        cell.lblTitle.textAlignment = .center
                    }
                    cell.oltSubmitRating.isHidden = true
                    cell.txtComment.isHidden = true
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat = 0.0
        if section == 0 {
            let objData = dataArray[indexPath.row]
            if objData.post.hasImage {
                height = 284
            }
            else if objData.post.hasImage == false {
                height = 70
            }
        }
        else if section == 1 {
            height = contentHeight[indexPath.row] + 80
        }
        else if section == 2 {
            height = UITableViewAutomaticDimension
        }
        else if section == 3 {
            height = UITableViewAutomaticDimension
        }
        else if section == 4 {
            if defaults.bool(forKey: "isGuest") {
                height = 0
            }
            else {
                let objData = dataArray[indexPath.row]
                if objData.post.commentStatus == "open" {
                    height = 220
                }
                else if objData.post.commentStatus == "closed" {
                    height = 50
                }
            }
        }
        return height
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        if contentHeight[webView.tag] != 0.0 {
            return
        }
        contentHeight[webView.tag] = webView.scrollView.contentSize.height
        tableView.reloadRows(at: [IndexPath(row: webView.tag, section: 0)], with: .automatic )
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
    
    func adForest_blogDetail(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.blogDetail(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
            self.title = successResponse.extra.pageTitle
            UserHandler.sharedInstance.objBlog = successResponse
            self.dataArray = [successResponse.data]
            self.commentArray = successResponse.data.post.comments.comments
            // capture reply from comments
                for reply in successResponse.data.post.comments.comments {
                    self.replyArray = reply.reply
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
    
    // blog post comment
    func adForest_blogPostComment(param: NSDictionary) {
        self.showLoader()
        UserHandler.blogPostComment(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    let param: [String: Any] = ["post_id": self.post_id]
                    print(param)
                    self.adForest_blogDetail(parameter: param as NSDictionary)
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
