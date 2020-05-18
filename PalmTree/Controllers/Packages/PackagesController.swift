//
//  PackagesController.swift
//  PalmTree
//
//  Created by SprintSols on 3/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import DropDown
import NVActivityIndicatorView
import StoreKit
import SwiftyStoreKit
import GoogleMobileAds
import IQKeyboardManagerSwift

protocol PaymentTypeDelegate {
    func paymentMethod(methodName: String, inAppID: String, packageID: String)
}

class PackagesController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, PaymentTypeDelegate, GADBannerViewDelegate, GADInterstitialDelegate,UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate {
  
    //MARK:- Outlets
    @IBOutlet weak var lblNoData: UILabel!{
        didSet {
            lblNoData.isHidden = true
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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
        }
    }
    
    //MARK:- Properties
    let addData = UserHandler.sharedInstance.objAdMob
    let defaults = UserDefaults.standard
    var dataArray = [PackagesDataProduct]()
    var isAppOpen = false
    var isSale = true
    var inAppSecretKey = ""
    var inApp_id = ""
    var package_id = ""
    var interstitial: GADInterstitial?
    var moreCatArr = [String]()
    var regularPrice = String()
  
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
    
  
    
    //MARK:- Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage()
        self.googleAnalytics(controllerName: "Packages Controller")
        if defaults.bool(forKey: "isLogin") == false {
            self.oltAdPost.isHidden = true
        }
       self.adMob()
       navigationButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.adForest_pakcagesData()
//        interstitial?.delegate = self
//        interstitial = self.appDelegate.createAndLoadInterstitial()
//        self.appDelegate.interstitial?.delegate = self
//        self.appDelegate.interstitial = self.appDelegate.createAndLoadInterstitial()
    }
    
    //MARK: - Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
//    func createAndLoadInterstitial() -> GADInterstitial? {
//        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3521346996890484/7679081330")
//        guard let interstitial = interstitial else {
//            return nil
//        }
//        let request = GADRequest()
//        interstitial.delegate = self
//        interstitial.load(request)
//        return interstitial
//    }
    
//    func adMobSetup() {
//        self.appDelegate.adBannerView.delegate = self
//        self.appDelegate.adBannerView.rootViewController = self
//        self.appDelegate.adBannerView.load(GADRequest())
//    }
//
//    //MARK:- AdMob Delegates
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
//        bannerView.transform = translateTransform
//        UIView.animate(withDuration: 0.5) {
//            bannerView.transform = CGAffineTransform.identity
//        }
//    }
//
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        print("Fail to receive ads")
//        print(error)
//    }
//
//    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
//        ad.present(fromRootViewController: self)
//    }
//
//    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
//        print("Fail to receive interstitial")
//    }
    
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
                        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     
             return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackagesCell", for: indexPath) as! PackagesCell
        let objData = dataArray[indexPath.row]
        let paymentData = UserHandler.sharedInstance.objPaymentType
        cell.btnMore.isHidden = true
        if let name = objData.productTitle {
            cell.lblOfferName.text = name
        }
        if objData.isSale == nil{
            isSale = false
        }else {
            isSale = true
        }
        
        if isSale == true {
            cell.imgSale.isHidden = false
            regularPrice = objData.regularPrice
            if let sale =  objData.saleText{
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrice)
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.lblSale.attributedText = attributeString
                cell.lblregularPrice.text = "\(sale)"
            }
        }
        else{
            cell.lblregularPrice.text = ""
            cell.lblSale.text = ""
            cell.imgSale.isHidden = true
        }
        if let price = objData.productPrice {
            cell.lblPrice.text = price
        }
        if let mainColor = defaults.string(forKey: "mainColor") {
            cell.lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            cell.lblSale.textColor = Constants.hexStringToUIColor(hex: mainColor)
            cell.lblregularPrice.textColor = UIColor.white

        }
        if let validityText = objData.daysText {
            if let daysvalue = objData.daysValue {
                cell.lblValidity.text = "\(validityText): \(daysvalue)"
            }
        }
        if objData.daysText == nil{
            cell.img1HeightConst.constant = 0
            cell.heightConstValid.constant = 0
        }
        
        
        if let freeAdsText = objData.freeAdsText {
            if let freeAdsValue = objData.freeAdsValue {
                cell.lblFreeAds.text = "\(freeAdsText): \(freeAdsValue)"
            }
        }
        if objData.freeAdsText == nil{
            cell.img2HeightConst.constant = 0
            cell.heightConstFree.constant = 0
        }
        
        
        if let fearureAdsText = objData.featuredAdsText {
            if let featureAdValue = objData.featuredAdsValue {
                cell.lblFeaturedAds.text = "\(fearureAdsText): \(featureAdValue)"
            }
        }
        if objData.featuredAdsText == nil{
            cell.img3HeightConst.constant = 0
            cell.heightConstFeature.constant = 0
        }
        

        if let bumpUptext = objData.bumpAdsText {
            if let bumpValue = objData.bumpAdsValue {
                cell.lblBumpUpAds.text = "\(bumpUptext): \(bumpValue)"
            }
        }
        
        if objData.bumpAdsText == nil{
            cell.img4HeightConst.constant = 0
            cell.heightConstBump.constant = 0
        }
        
        if let paymentTypeButton = objData.paymentTypesValue {
            cell.buttonSelectOption.setTitle(paymentTypeButton, for: .normal)
        }
        
        if let allow_bidding_text = objData.allow_bidding_text {
            if let allow_bidding_val = objData.allow_bidding_value {
                cell.lblAllowBidValue.text = "\(allow_bidding_text): \(allow_bidding_val)"
            }
        }

        if objData.allow_bidding_text == nil{
            cell.img5.isHidden = true
            cell.img5HeightConst.constant = 0
            cell.heightConstBid.constant = 0
        }
        
        if let num_of_images_text = objData.num_of_images_text {
            if let num_of_images_val = objData.num_of_images_val {
                cell.lblNumOfImgValue.text = "\(num_of_images_text): \(num_of_images_val)"
            }
        }
        if objData.num_of_images_text == nil{
            cell.img6HeightConst.constant = 0
            cell.heightConstNumImg.constant = 0
        }
        
        
        if let video_url_text = objData.video_url_text {
            if let video_url_val = objData.video_url_val {
                cell.lblVidUrlVal.text = "\(video_url_text): \(video_url_val)"
            }
        }
        
        if objData.video_url_text == nil{
            cell.img7HeightConst.constant = 0
            cell.heightConstVideo.constant = 0
        }
        
        if let allow_tags_text = objData.allow_tags_text{
            if let allow_tags_val = objData.allow_tags_val {
                cell.lblAllowTagVal.text = "\(allow_tags_text): \(allow_tags_val)"
            }
        }
        if objData.allow_tags_text == nil{
            cell.img8HeightConst.constant = 0
            cell.heightConstTag.constant = 0
        }
    
        if let allow_cats_text = objData.allow_cats_text {
            if let allow_cats_val = objData.allow_cats_val {
                cell.lblAllowCatVal.text = "\(allow_cats_text): \(allow_cats_val)"
            }
        }
        if objData.allow_cats_text == nil{
            cell.img9HightConst.constant = 0
            cell.heightConstAllCat.constant = 0
        }else{
            UserDefaults.standard.set(objData.allow_cats_text, forKey: "allowText")
        }
        
        if let allow_cats_text = objData.allow_cats_text {
            for ob in objData.allow_cats_valArr{
                if let catName = ob.cat_name{
                    let bgColor = defaults.string(forKey: "mainColor")
               
                    let strokeTextAttributes: [NSAttributedString.Key: Any] = [
                        .strokeColor : UIColor(hex: bgColor!),
                        .foregroundColor : UIColor(hex: bgColor!),
                        .strokeWidth : -2.0,
                        NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                        NSAttributedStringKey.underlineColor: UIColor(hex: bgColor!)
                        //.font : UIFont.boldSystemFont(ofSize: 18)
                    ]
            let underlineAttributedString = NSAttributedString(string: objData.seeAll, attributes: strokeTextAttributes)
                    let yourAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
                    let partOne = NSMutableAttributedString(string: "\(allow_cats_text): ", attributes: yourAttributes)
                    let combination = NSMutableAttributedString()
                    combination.append(partOne)
                    combination.append(underlineAttributedString)
                    cell.lblAllowCatVal.attributedText = combination //underlineAttributedString
                     moreCatArr.append(catName)
                    cell.btnMore.isHidden = false
                    cell.btnMore.setTitle("", for: .normal)
                     
                    //cell.catNewArr = objData.allow_cats_valArr
            
                }
            }
            cell.catNewArr = objData.allow_cats_valArr
            cell.catArr = moreCatArr
        }
        
        cell.package_id = objData.productId
        cell.dropShow = { () in
            if self.defaults.bool(forKey: "isLogin") == false {
                if let msg = self.defaults.string(forKey: "notLogin") {
                    let alert = Constants.showBasicAlert(message: msg)
                    self.presentVC(alert)
                }
            } else {
                cell.dropDownValueArray = []
                if (paymentData?.paymentTypes.isEmpty)! {
                } else {
                    for items in (paymentData?.paymentTypes)! {
                        if items.key == "" {
                            continue
                        }
                        cell.dropDownValueArray.append(items.value)
                        cell.dropDownKeyArray.append(items.key)
                    }
                    if self.isAppOpen {
                        cell.selectedInAppPackage = objData.productAppCode.ios
                    }
                    cell.delegate = self
                    cell.selectCategory()
                    cell.categoryDropDown.show()
                }
            }
        }
        return cell
       
    }
    
   // @objc func onMoreButtonClciked() {
    
    
//        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 135))
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.isScrollEnabled = false
//        self.popover = Popover(options: self.popoverOptions)
//        self.popover.willShowHandler = {
//            print("willShowHandler")
//        }
//        self.popover.didShowHandler = {
//            print("didDismissHandler")
//        }
//        self.popover.willDismissHandler = {
//            print("willDismissHandler")
//        }
//        self.popover.didDismissHandler = {
//            print("didDismissHandler")
//        }
//        self.popover.show(tableView, fromView: self.tableViewPackages)
    
        
//        let moreCatVc = self.storyboard?.instantiateViewController(withIdentifier: "PackagesMoreCatViewController") as! PackagesMoreCatViewController
//        moreCatVc.catArr = moreCatArr
//        moreCatVc.modalPresentationStyle = .overCurrentContext
//        moreCatVc.modalTransitionStyle = .crossDissolve
//       self.present(moreCatVc, animated: true)
//        //self.navigationController?.pushViewController(moreCatVc, animated: true)
    //}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
            return 366
        

    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return self.appDelegate.adBannerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return self.appDelegate.adBannerView.frame.height
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
    
    
    //MARK:- Change Status delegate
    func paymentMethod(methodName: String, inAppID: String, packageID: String) {
         if methodName == "app_inapp" {
            self.inApp_id = inAppID
            self.package_id = packageID
            self.adForest_MoveToInAppPurchases()
        } else {
            print("Not Found")
        }
    }
    
    //MARK:- In App Method
    func adForest_MoveToInAppPurchases() {
        self.purchaseProduct(productID: self.inApp_id)
    }
    
    func getInfo() {
        self.showNavigationActivity()
        SwiftyStoreKit.retrieveProductsInfo([inApp_id], completion: {
            result in
            self.hideNavigationActivity()
            self.showAlert(alert: self.alertForProductRetrivalInfo(result: result))
        })
    }
    
    func purchaseProduct(productID: String) {
        self.showLoader()
//        self.showNavigationActivity()
        SwiftyStoreKit.purchaseProduct(inApp_id, completion: {
            result in
//            self.hideNavigationActivity()
            self.stopAnimating()

            if case .success(let product) = result {
                let parameters: [String: Any] = [
                    "package_id": self.package_id,
                    "payment_from": "app_inapp"
                ]
                print(parameters)
                self.adForest_paymentConfirmation(parameter: parameters as NSDictionary)
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
               // self.showAlert(alert: self.alertForPurchasedResult(result: result))
            }
        })
    }

    func restorePurchase() {
        self.showNavigationActivity()
        SwiftyStoreKit.restorePurchases(atomically: true,  completion: {
            result in
            self.hideNavigationActivity()
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            self.showAlert(alert: self.alertForRestorePurchase(result: result))
        })
    }
    
    func verifyReceipt() {
        self.showNavigationActivity()
        let validator = AppleReceiptValidator(service: .production, sharedSecret: inAppSecretKey)
        SwiftyStoreKit.verifyReceipt(using: validator, completion: {
            result in
            self.hideNavigationActivity()
            self.showAlert(alert: self.alertForVerifyReceipt(result: result))
            
            if case .error(let error)  = result {
                if case .noReceiptData = error {
                    self.refreshReceipt()
                }
            }
        })
    }
    
    func verifyPurchase() {
        self.showNavigationActivity()
        let validator = AppleReceiptValidator(service: .production, sharedSecret: inAppSecretKey)
        SwiftyStoreKit.verifyReceipt(using: validator, completion: {
            result in
            self.hideNavigationActivity()
            switch result {
            case .success(let receipt):
                let productID = self.inApp_id
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                self.showAlert(alert: self.alertForVerifyPurchase(result: purchaseResult))
            case .error(let error):
                self.showAlert(alert: self.alertForVerifyReceipt(result: result))
                if case .noReceiptData = error {
                    self.refreshReceipt()
                }
            }
        })
    }
    
    func refreshReceipt() {
        let validator = AppleReceiptValidator(service: .production, sharedSecret: inAppSecretKey)
        SwiftyStoreKit.verifyReceipt(using: validator, completion: {
            result in
            self.showAlert(alert: self.alertForRefreshReceipt(result: result))
        })
    }
 
    //MARK:- IBActions
    @IBAction func actionAdPost(_ sender: Any) {
        
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
    func adForest_pakcagesData() {
        self.showLoader()
        UserHandler.packagesdata(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.extra.pageTitle
                self.dataArray = successResponse.data.products
                UserHandler.sharedInstance.objPaymentType = successResponse.data
                if let isApp = successResponse.extra.ios.inAppOn {
                    self.isAppOpen = isApp
                }
                if self.isAppOpen {
                    if let secretKey = successResponse.extra.ios.secretCode {
                        self.inAppSecretKey = secretKey
                    }
                }
                self.tableView.reloadData()
            }
            else {
                self.lblNoData.isHidden = false
                self.lblNoData.text = successResponse.message
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // payment confirmation
    func adForest_paymentConfirmation(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.paymentConfirmation(parameters: parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let paymentSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessController") as! PaymentSuccessController
                self.presentVC(paymentSuccessVC)
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


extension PackagesController {
    func alertWithTitle(title: String, message: String)-> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(alert: UIAlertController) {
        guard let _ = self.presentedViewController else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrivalInfo(result: RetrieveResults)-> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        }
        else if let invalidProductID = result.invalidProductIDs.first {
            return alertWithTitle(title: "Could Not retrieve Info", message: "Invalid Product ID: \(invalidProductID)")
        }
        else {
            let errorString = result.error?.localizedDescription ?? "Unknown Error. Please Contact Support"
            return alertWithTitle(title: "Could not retrieve info", message: errorString)
        }
    }
    
    
    func alertForPurchasedResult(result: PurchaseResult)-> UIAlertController {
        
        switch result {
        case .success(let purchase):
             print("Purchase SuccessFfull: \(purchase.productId)")
             return alertWithTitle(title: "Thank You", message: "Purchase Completed")
        case .error(let error):
            return alertWithTitle(title: "Error", message: "\(error)")
        }
    }
    
    func alertForRestorePurchase(result: RestoreResults)-> UIAlertController {
        
        if result.restoredPurchases.count > 0 {
            print("restore Failed \(result.restoredPurchases)")
            return alertWithTitle(title: "Restore Failed", message: "Error. Please Contact Support")
        }
        else if result.restoredPurchases.count > 0 {
            return alertWithTitle(title: "Purchase Restored", message: "All Purchases Have been restored")
        }
        else {
            return alertWithTitle(title: "Nothing to restore", message: "No previous purchases were made")
        }
    }
    
    
    func alertForVerifyReceipt(result: VerifyReceiptResult)-> UIAlertController {
        
        switch result {
        case .success( _):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        case .error(let error):
            switch error {
            case .noReceiptData:
                return alertWithTitle(title: "Receipt Verification", message: "No receipt data found, application will try to get a new one. Try again")
            default:
                return alertWithTitle(title: "Receipt Verification", message: "Receipt Verification Failed.")
            }
        }
    }
    
    func alertForVerifySubscription(result: VerifySubscriptionResult)-> UIAlertController {
        switch result {
        case .purchased(let expiryDate):
            return alertWithTitle(title: "Product is Purchased", message: "Product is valid until \(expiryDate)")
        case .notPurchased:
            return alertWithTitle(title: "Not Purchased", message: "This product has never been purchased")
        case .expired(let expiryDate):
            return alertWithTitle(title: "Product Expired", message: "Product is expire since \(expiryDate)")
        }
    }
    
    func alertForVerifyPurchase(result: VerifyPurchaseResult)-> UIAlertController {
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is purchased", message: "Product will not expire")
        case .notPurchased:
            return alertWithTitle(title: "Product not purchased", message: "Product has never been purchased")
        }
    }
    
    func alertForRefreshReceipt(result: VerifyReceiptResult) -> UIAlertController {
        switch result {
        case .success( _):
            return alertWithTitle(title: "Receipt refresh", message: "receipt refresh successfully")
        case .error( _):
            return alertWithTitle(title: "Receipt refresh failed", message: "Receipt refresh failed")
        }
    }
}
