//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ImageSlideshow
import Social
import SwiftGoogleTranslate

class AdDetailVC: UIViewController, NVActivityIndicatorViewable, moveTomessagesDelegate
{
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var summaryBtn: UIButton!
    @IBOutlet weak var specsBtn: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var whatsappBtn: UIButton!
    @IBOutlet weak var readBtn: UIButton!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var lblSummary: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSeller: UILabel!
    @IBOutlet weak var lblJoining: UILabel!
    @IBOutlet weak var lblListing: UILabel!
    @IBOutlet weak var lblSellerTypeText: UILabel!
    @IBOutlet weak var lblSellerType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblID: UILabel!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var sellerView: UIView!
    @IBOutlet weak var callingView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var specsHeight: NSLayoutConstraint!
    @IBOutlet weak var specsView: UIView!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var transBtn: UIButton!
    
    //MARK:- Properties
    var adDetailDataObj:AdsJSON!
    var sourceImages = [ImageSource]()
    var inputImages = [InputSource]()
    var readFlag = false
    var fromVC = ""
    
    var summaryViewHeight: CGFloat = 0.0
    var specsViewHeight: CGFloat = 0.0
    var ad_id = 0
    var phone = ""
    var priceType = ""
    var sellerName = ""
    var sendMsgbuttonType = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleAnalytics(controllerName: "Ad Details Controller")

        populateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: 0, height: 1000)
    }
    
    //MARK:- Custom Functions
    
    func populateData()
    {
        if languageCode == "ar"
        {
            lblName.textAlignment = .right
        }
        
        lblName.text = adDetailDataObj.title
        
//        if let name = adDetailDataObj.title
//        {
//            SwiftGoogleTranslate.shared.detect(name) { (detections, error) in
//                if let detections = detections
//                {
//                    for detection in detections
//                    {
//                        print(detection.language)
//
//                        if languageCode == "ar" && detection.language != "ar"
//                        {
//                            SwiftGoogleTranslate.shared.translate(name, "ar", detection.language) { (text, error) in
//                                if let titleText = text {
//                                    DispatchQueue.main.async {
//                                        self.lblName.text = titleText
//                                    }
//                                }
//                                else
//                                {
//                                    DispatchQueue.main.async {
//                                        self.lblName.text = name
//                                    }
//                                }
//                            }
//                        }
//                        else if languageCode == "en" && detection.language != "en"
//                        {
//                            SwiftGoogleTranslate.shared.translate(name, "en", detection.language) { (text, error) in
//                                if let titleText = text {
//                                    DispatchQueue.main.async {
//                                        self.lblName.text = titleText
//                                    }
//                                }
//                                else
//                                {
//                                    DispatchQueue.main.async {
//                                        self.lblName.text = name
//                                    }
//                                }
//                            }
//                        }
//                        else
//                        {
//                            DispatchQueue.main.async {
//                                self.lblName.text = name
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        var price = adDetailDataObj.price ?? ""
        priceType = adDetailDataObj.price_type ?? ""
        
        if priceType != ""
        {
            if languageCode == "ar"
            {
                priceType = NSLocalizedString(priceType, comment: "")
            }
            else if priceType == "سعر ثابت"
            {
                priceType = "Fixed"
            }
            else if priceType == "قابل للتفاوض"
            {
                priceType = "Negotiable"
            }
            
            price = String(format: "AED %@ (%@)", price, priceType)
        }
        
        lblPrice.text = price
        lblLocation.text = adDetailDataObj.address
        
        lblSummary.text = adDetailDataObj.description
        
//        if let descp = adDetailDataObj.description
//        {
//            SwiftGoogleTranslate.shared.detect(descp) { (detections, error) in
//                if let detections = detections
//                {
//                    for detection in detections
//                    {
//                        print(detection.language)
//
//                        if languageCode == "ar" && detection.language != "ar"
//                        {
//                            SwiftGoogleTranslate.shared.translate(descp, "ar", detection.language) { (text, error) in
//                              if let titleText = text {
//                                DispatchQueue.main.async {
//                                    self.lblSummary.text = titleText
//                                }
//                              }
//                            }
//                        }
//                        else if languageCode == "en" && detection.language != "en"
//                        {
//                            SwiftGoogleTranslate.shared.translate(descp, "en", detection.language) { (text, error) in
//                              if let titleText = text {
//                                DispatchQueue.main.async {
//                                    self.lblSummary.text = titleText
//                                }
//                              }
//                            }
//                        }
//                        else
//                        {
//                            DispatchQueue.main.async {
//                                self.lblSummary.text = descp
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
        lblID.text = String(format: "ID: %i", adDetailDataObj.id ?? 0)
        
        
        if defaults.bool(forKey: "isLogin") == true
        {
            if adDetailDataObj.isFavorite
            {
                favBtn.setImage(UIImage(named: "favourite_active"), for: .normal)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: adDetailDataObj.createdAt ?? "")
        
        if date != nil
        {
            lblTime.text = timeAgoSince(date!)
        }
        lblSeller.text = adDetailDataObj.username

        if let joining = adDetailDataObj.userjoin
        {
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
        
        if adDetailDataObj.phone == ""
        {
            callBtn.isEnabled = false
        }
        else
        {
            callBtn.isEnabled = true
        }
        
        if adDetailDataObj.whatsapp == ""
        {
            whatsappBtn.isEnabled = false
        }
        else
        {
            whatsappBtn.isEnabled = true
        }
        
        if adDetailDataObj.images.count > 0
        {
            fillSlideShow()
        }
        
        if adDetailDataObj.customFields.count > 0
        {
            tabView.alpha = 1
            top.constant = 55
            createSpecsView()
            summaryViewHeight = 135
            height.constant = summaryViewHeight
        }
        else
        {
            top.constant = 15
            tabView.alpha = 0
            height.constant = 60
            summaryViewHeight = 110
        }
        
        let txtHeight = lblSummary.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
        
        if txtHeight > 60.0
        {
            readBtn.alpha = 1
            summaryViewHeight += txtHeight
            height.constant = summaryViewHeight
        }
        
        if defaults.bool(forKey: "isLogin") == true
        {
            if adDetailDataObj.userID == userDetail?.id
            {
                callingView.alpha = 0
                reportBtn.alpha = 0
            }
            else
            {
                callingView.alpha = 1
                reportBtn.alpha = 1
            }
        }
    }
    
    func fillSlideShow()
    {
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.activityIndicator = DefaultActivityIndicator()
        
        slideshow.currentPageChanged = { page in
        }
        
        for image in adDetailDataObj.images
        {
            let alamofireSource = AlamofireSource(urlString: String(format: "%@%@", Constants.URL.imagesUrl, image.url.encodeUrl()))!
            inputImages.append(alamofireSource)
        }
        
        slideshow.setImageInputs(inputImages)
        
        if #available(iOS 13.0, *) {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            slideshow.addGestureRecognizer(recognizer)
                   inputImages.removeAll()
        }
        else
        {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap12))
            slideshow.addGestureRecognizer(recognizer)
                   inputImages.removeAll()
        }
    }
    
    func createSpecsView()
    {
        specsViewHeight = 0
        var viewsHeight: CGFloat = 10.0
        
        for fieldData in adDetailDataObj.customFields
        {
            let makeView = createView(yAxis: viewsHeight, text: fieldData.name, value: fieldData.value)
            specsView.addSubview(makeView)
            viewsHeight += 60
        }
        
        if viewsHeight > 10
        {
            specsViewHeight = viewsHeight
            specsHeight.constant = specsViewHeight
        }
    }
    
    func createView(yAxis: CGFloat, text: String, value: String) -> UIView
    {
        let view = UIView()
        view.frame = CGRect(x: 15, y: yAxis, width: screenWidth - 30, height: 60)
        view.backgroundColor = .clear
        
        let lblText = UILabel()
        lblText.frame = CGRect(x: 0, y: 20, width: 100, height: 20)
        lblText.backgroundColor = .clear
        lblText.text = text
        lblText.font = UIFont.systemFont(ofSize: 15)
        lblText.textColor = UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 131.0/255.0, alpha: 1)
        
        let lblValue = UILabel()
        lblValue.frame = CGRect(x: view.frame.width - 200, y: 20, width: 200, height: 20)
        lblValue.backgroundColor = .clear
        lblValue.text = value
        lblValue.font = UIFont.systemFont(ofSize: 15)
        lblValue.textAlignment = .right
        lblValue.textColor = UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1)
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: 59.5, width: view.frame.width, height: 0.5)
        lineView.backgroundColor = .lightGray
        lineView.alpha = 0.5
        
        view.addSubview(lblText)
        view.addSubview(lblValue)
        view.addSubview(lineView)
        
        return view
    }
    
    func isMoveMessages(isMove: Bool)
    {
        
    }
    
    @available(iOS 13.0, *)
    @objc func didTap()
    {
          let fullScreenController = slideshow.presentFullScreenController(from: self)
          // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
    
          fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
      
    @objc func didTap12()
    {
         let fullScreenController = slideshow.presentFullScreenController(from: self)
   
         fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    //MARK:- IBActions
    @IBAction func translationBtnAction(_ sender: Any)
    {
        if let name = adDetailDataObj.title
        {
            SwiftGoogleTranslate.shared.detect(name) { (detections, error) in
                if let detections = detections
                {
                    for detection in detections
                    {
                        print(detection.language)

                        if detection.language == "ar" || detection.language == "sd"
                        {
                            SwiftGoogleTranslate.shared.translate(name, "en", detection.language) { (text, error) in
                                if let titleText = text {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: titleText)
                                        self.presentVC(alert)
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: name)
                                        self.presentVC(alert)
                                    }
                                }
                            }
                        }
                        else
                        {
                            SwiftGoogleTranslate.shared.translate(name, "ar", detection.language) { (text, error) in
                                if let titleText = text {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: titleText)
                                        self.presentVC(alert)
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: name)
                                        self.presentVC(alert)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func descpTransBtnAction(_ sender: Any)
    {
        if let descp = adDetailDataObj.description
        {
            SwiftGoogleTranslate.shared.detect(descp) { (detections, error) in
                if let detections = detections
                {
                    for detection in detections
                    {
                        print(detection.language)

                        if detection.language == "ar" || detection.language == "sd"
                        {
                            SwiftGoogleTranslate.shared.translate(descp, "en", detection.language) { (text, error) in
                                if let titleText = text
                                {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: titleText)
                                        self.presentVC(alert)
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: descp)
                                        self.presentVC(alert)
                                    }
                                }
                            }
                        }
                        else
                        {
                            SwiftGoogleTranslate.shared.translate(descp, "ar", detection.language) { (text, error) in
                                if let titleText = text {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: titleText)
                                        self.presentVC(alert)
                                    }
                                }
                                else
                                {
                                    DispatchQueue.main.async {
                                        let alert = Constants.showBasicAlert(message: descp)
                                        self.presentVC(alert)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnAction(_ sender: Any)
    {
        var objectsToShare = [AnyObject]()
        objectsToShare.append(adDetailDataObj.title as AnyObject)

        if adDetailDataObj.images.count > 0
        {
            objectsToShare.append(String(format: "%@%@", Constants.URL.imagesUrl, adDetailDataObj.images[0].url.encodeUrl()) as AnyObject)
        }

        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func locationBtnAction(_ sender: Any)
    {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.address = adDetailDataObj.address ?? ""
        mapVC.latitude = Double(adDetailDataObj.latitude ?? "0.0")
        mapVC.longitude = Double(adDetailDataObj.longitude ?? "0.0")
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func socialBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                vc.setInitialText(adDetailDataObj.title)
                if adDetailDataObj.images.count > 0
                {
                    vc.add(URL(string: String(format: "%@%@", Constants.URL.imagesUrl, adDetailDataObj.images[0].url.encodeUrl())))
                }
                present(vc, animated: true)
            }
        }
        else
        {
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                vc.setInitialText(adDetailDataObj.title)
                if adDetailDataObj.images.count > 0
                {
                    vc.add(URL(string: String(format: "%@%@", Constants.URL.imagesUrl, adDetailDataObj.images[0].url.encodeUrl())))
                }
                present(vc, animated: true)
            }
        }
    }
    
    @IBAction func favBtnAction(_ sender: Any)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            if !adDetailDataObj.isFavorite
            {
                let parameter: [String: Any] = ["ad_id": adDetailDataObj.id ?? 0, "user_id" : userDetail?.id ?? 0]
                self.makeAddFavourite(param: parameter as NSDictionary)
            }
            else
            {
                self.showToast(message: NSLocalizedString(String(format: "fav_already_%@",languageCode), comment: ""))
            }
        }
    }
    
    @IBAction func readBtnAction(_ sender: Any)
    {
        if readFlag
        {
            if languageCode == "ar"
            {
                readBtn.setTitle("قراءة المزيد", for: .normal)
            }
            else
            {
                readBtn.setTitle("Read More", for: .normal)
            }
            readFlag = false
            height.constant = 195
        }
        else
        {
            if languageCode == "ar"
            {
                readBtn.setTitle("أقرأ أقل", for: .normal)
            }
            else
            {
                readBtn.setTitle("Read Less", for: .normal)
            }
            readFlag = true
            height.constant = 195
        }
    }
    
    @IBAction func clickBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            self.leading.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            summaryBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            specsBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
            
            lblSummary.alpha = 1
            specsView.alpha = 0
            summaryViewHeight = 135
            let txtHeight = lblSummary.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
            
            if txtHeight > 85.0
            {
                readBtn.alpha = 1
                summaryViewHeight = txtHeight + 55
            }
            
            height.constant = summaryViewHeight
            scrollView.contentSize = CGSize(width: 0, height: 800 + summaryViewHeight)
            
        }
        else
        {
            leading.constant = screenWidth/2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            specsBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            summaryBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
            lblSummary.alpha = 0
            readBtn.alpha = 0
            specsView.alpha = 1
            height.constant = specsViewHeight + 55
            scrollView.contentSize = CGSize(width: 0, height: 800 + specsViewHeight)
        }
    }
    
    @IBAction func chatBtnAction(_ button: UIButton)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {            
            let sendMsgVC = storyboard?.instantiateViewController(withIdentifier: ReplyCommentController.className) as! ReplyCommentController
            sendMsgVC.modalPresentationStyle = .overCurrentContext
            sendMsgVC.modalTransitionStyle = .flipHorizontal
            sendMsgVC.isFromMsg = true
            sendMsgVC.delegate = self
            sendMsgVC.firebaseID = adDetailDataObj.chatToken
            present(sendMsgVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func callBtnAction(_ button: UIButton)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            if let phoneURL = URL(string: String(format: "tel://+971%@", adDetailDataObj.phone))
            {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func whatsappBtnAction(_ button: UIButton)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            let whatsappURL = URL(string: String(format: "https://wa.me/+971%@", adDetailDataObj.whatsapp))
            if UIApplication.shared.canOpenURL(whatsappURL!) {
                UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func reportBtnAction(_ button: UIButton)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated:true, completion: nil)
        }
        else
        {
            let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportController") as! ReportController
            reportVC.modalPresentationStyle = .overCurrentContext
            reportVC.modalTransitionStyle = .crossDissolve
            reportVC.adID = adDetailDataObj.id ?? 0
            self.presentVC(reportVC)
        }
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func makeAddFavourite(param: NSDictionary) {
        self.showLoader()
        AddsHandler.makeAddFavourite(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                DispatchQueue.main.async {
                    self.favBtn.setImage(UIImage(named: "favourite_active"), for: .normal)
                }
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            let alert = Constants.showBasicAlert(message: NSLocalizedString(String(format: "something_%@", languageCode), comment: ""))
            self.presentVC(alert)
        }
    }
}

public func timeAgoSince(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year) \(NSLocalizedString(String(format: "years_ago_%@",languageCode), comment: ""))"
    }
    
    if let year = components.year, year >= 1 {
        return (NSLocalizedString(String(format: "last_year_%@",languageCode), comment: ""))
    }
    
    if let month = components.month, month >= 2 {
        return "months ago"
    }
    
    if let month = components.month, month >= 1 {
        return (NSLocalizedString(String(format: "last_month_%@",languageCode), comment: ""))
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) \(NSLocalizedString(String(format: "weeks_ago_%@",languageCode), comment: ""))"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return (NSLocalizedString(String(format: "last_week_%@",languageCode), comment: ""))
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) \(NSLocalizedString(String(format: "days_ago_%@",languageCode), comment: ""))"
    }
    
    if let day = components.day, day >= 1 {
        return (NSLocalizedString(String(format: "Yesterday_%@",languageCode), comment: ""))
    }
    
    if let hour = components.hour, hour >= 2 {
        return (NSLocalizedString(String(format: "Today_%@",languageCode), comment: ""))
    }
    
    if let hour = components.hour, hour >= 1 {
        return (NSLocalizedString(String(format: "Today_%@",languageCode), comment: ""))
    }
    
    if let minute = components.minute, minute >= 2 {
        return (NSLocalizedString(String(format: "Today_%@",languageCode), comment: ""))
    }
    
    if let minute = components.minute, minute >= 1 {
        return (NSLocalizedString(String(format: "Today_%@",languageCode), comment: ""))
    }
    
    if let second = components.second, second >= 3 {
        return (NSLocalizedString(String(format: "Today_%@",languageCode), comment: ""))
    }
    
    return (NSLocalizedString(String(format: "Today_%@",languageCode), comment: ""))
}

public func timeAgoSinceShort(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year)y"
    }
    
    if let year = components.year, year >= 1 {
        return "1y"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month)m"
    }
    
    if let month = components.month, month >= 1 {
        return "1mo"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week)w"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "1w"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day)d"
    }
    
    if let day = components.day, day >= 1 {
        return "1d"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour)h"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "1h"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute)m"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "1m"
    }
    
    if let second = components.second, second >= 3 {
        return "\(second)s"
    }
    
    return "1s"
    
}
