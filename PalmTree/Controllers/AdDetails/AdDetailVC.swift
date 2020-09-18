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
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var specsView: UIView!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    //MARK:- Properties
    var adDetailDataObj:AdsJSON!
    var sourceImages = [ImageSource]()
    var inputImages = [InputSource]()
    
    var readFlag = false
    var fromVC = ""
    
    var txtHeight = 0
    var ad_id = 0
    var phone = ""
    var priceType = ""
    var sellerName = ""
    var sendMsgbuttonType = ""
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.googleAnalytics(controllerName: "Watchlist Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            summaryBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            specsBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnReport.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            callBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            chatBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            whatsappBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            readBtn.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnLocation.contentHorizontalAlignment = .right
            
            lblSummary.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSeller.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblJoining.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblListing.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSellerTypeText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSellerType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTime.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblID.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblName.textAlignment = .right
        }
        populateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: 0, height: 1000)
    }
    
    //MARK:- Custom Functions
    
    func populateData()
    {
        lblName.text = adDetailDataObj.title
        
        var price = adDetailDataObj.price ?? ""
        priceType = adDetailDataObj.price_type ?? ""
        
        if priceType != ""
        {
            if languageCode == "ar"
            {
                priceType = NSLocalizedString(priceType, comment: "")
            }
            
            price = String(format: "AED %@ (%@)", price, priceType)
        }
        
        lblPrice.text = price
        lblLocation.text = adDetailDataObj.address
        lblSummary.text = adDetailDataObj.description
        lblID.text = String(format: "ID: %i", adDetailDataObj.id ?? 0)
        
        
        if defaults.bool(forKey: "isLogin") == true
        {
            if adDetailDataObj.is_favorite
            {
                favBtn.setImage(UIImage(named: "favourite_active"), for: .normal)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: adDetailDataObj.created_at ?? "")
        
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
        
        height.constant = 60
        
        let txtHeight = lblSummary.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
        
        if txtHeight > 60.0
        {
            readBtn.alpha = 1
            height.constant = txtHeight
        }
        
        createSpecsView()
        
        if phone == ""
        {
            callBtn.isEnabled = false
            whatsappBtn.isEnabled = false
        }
        else
        {
            callBtn.isEnabled = true
            whatsappBtn.isEnabled = true
        }
        
        if adDetailDataObj.images.count > 0
        {
            fillSlideShow()
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
            let alamofireSource = AlamofireSource(urlString: image.url)!
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
        var specsHeight: CGFloat = 10.0
        
        if adDetailObj.motorCatObj.make != ""
        {
            let makeView = createView(yAxis: specsHeight, text: "Make", value: adDetailObj.motorCatObj.make)
            specsView.addSubview(makeView)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.model != ""
        {
            let makeView = createView(yAxis: specsHeight, text: "Model", value: adDetailObj.motorCatObj.model)
            specsView.addSubview(makeView)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.year != ""
        {
            let view = createView(yAxis: specsHeight, text: "Year", value: adDetailObj.motorCatObj.year)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.mileage != ""
        {
            let view = createView(yAxis: specsHeight, text: "Mileage", value: adDetailObj.motorCatObj.mileage)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.bodyType != ""
        {
            let view = createView(yAxis: specsHeight, text: "Body Type", value: adDetailObj.motorCatObj.bodyType)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.fuelType != ""
        {
            let view = createView(yAxis: specsHeight, text: "Fuel Type", value: adDetailObj.motorCatObj.fuelType)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.transmission != ""
        {
            let view = createView(yAxis: specsHeight, text: "Transmission", value: adDetailObj.motorCatObj.transmission)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.colour != ""
        {
            let view = createView(yAxis: specsHeight, text: "Colour", value: adDetailObj.motorCatObj.colour)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.motorCatObj.engineSize != ""
        {
            let view = createView(yAxis: specsHeight, text: "Engine Size", value: adDetailObj.motorCatObj.engineSize)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.propertyCatObj.propertyType != ""
        {
            let view = createView(yAxis: specsHeight, text: "Property Type", value: adDetailObj.propertyCatObj.propertyType)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.propertyCatObj.bedrooms != ""
        {
            let view = createView(yAxis: specsHeight, text: "No of Bedrooms", value: adDetailObj.propertyCatObj.bedrooms)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if adDetailObj.propertyCatObj.sellerType != ""
        {
            let view = createView(yAxis: specsHeight, text: "Seller Type", value: adDetailObj.propertyCatObj.sellerType)
            specsView.addSubview(view)
            specsHeight += 65
        }
        
        if specsHeight > 10
        {
            height.constant = specsHeight
            scrollView.contentSize = CGSize(width: 0, height: 720 + specsHeight)
        }
        else
        {
            if tabView != nil
            {
                tabView.removeFromSuperview()
            }
        }
    }
    
    func createView(yAxis: CGFloat, text: String, value: String) -> UIView
    {
        let view = UIView()
        view.frame = CGRect(x: 15, y: yAxis, width: screenWidth - 30, height: 50)
        view.backgroundColor = .clear
        
        let lblText = UILabel()
        lblText.frame = CGRect(x: 0, y: 15, width: 100, height: 20)
        lblText.backgroundColor = .clear
        lblText.text = text
        lblText.font = UIFont.systemFont(ofSize: 15)
        lblText.textColor = UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 131.0/255.0, alpha: 1)
        
        let lblValue = UILabel()
        lblValue.frame = CGRect(x: view.frame.width - 100, y: 15, width: 100, height: 20)
        lblValue.backgroundColor = .clear
        lblValue.text = value
        lblValue.font = UIFont.systemFont(ofSize: 15)
        lblValue.textAlignment = .right
        lblValue.textColor = UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1)
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 0, y: 49.5, width: view.frame.width, height: 0.5)
        lineView.backgroundColor = .lightGray
        lineView.alpha = 0.5
        
        view.addSubview(lblText)
        view.addSubview(lblValue)
        view.addSubview(lineView)
        
        return view
    }
    
    func isMoveMessages(isMove: Bool)
    {
        let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: MessagesController.className) as! MessagesController
        messagesVC.isFromAdDetail = true
        self.navigationController?.pushViewController(messagesVC, animated: true)
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
            objectsToShare.append(adDetailDataObj.images[0].url as AnyObject)
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
                    vc.add(URL(string: adDetailDataObj.images[0].url))
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
                    vc.add(URL(string: adDetailDataObj.images[0].url))
                }
                present(vc, animated: true)
            }
        }
    }
    
    @IBAction func favBtnAction(_ sender: Any)
    {
        let parameter: [String: Any] = ["ad_id": adDetailDataObj.id ?? 0, "user_id" : userDetail?.id ?? 0]
        self.makeAddFavourite(param: parameter as NSDictionary)
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
            let txtHeight = lblSummary.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
            
            if txtHeight > 85.0
            {
                readBtn.alpha = 1
                height.constant = txtHeight + 55
            }
        }
        else
        {
            readBtn.alpha = 0
            leading.constant = screenWidth/2
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            specsBtn.setTitleColor(UIColor(red: 62.0/255.0, green: 49.0/255.0, blue: 66.0/255.0, alpha: 1), for: .normal)
            summaryBtn.setTitleColor(UIColor(red: 131.0/255.0, green: 131.0/255.0, blue: 130.0/255.0, alpha: 1), for: .normal)
            lblSummary.alpha = 0
//            let txtHeight = lblSpecs.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
//
//            if txtHeight > 85.0
//            {
//                height.constant = txtHeight
//            }
        }
    }
    
    @IBAction func chatBtnAction(_ button: UIButton)
    {
        if defaults.bool(forKey: "isLogin") == false
        {
            if let msg = defaults.string(forKey: "notLogin")
            {
                let alert = Constants.showBasicAlert(message: msg)
                presentVC(alert)
            }
        }
        else
        {
            if sendMsgbuttonType == "receive"
            {
                let msgVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
                msgVC.isFromAdDetail = true
                self.navigationController?.pushViewController(msgVC, animated: true)
            }
            else
            {
                let sendMsgVC = storyboard?.instantiateViewController(withIdentifier: ReplyCommentController.className) as! ReplyCommentController
                sendMsgVC.modalPresentationStyle = .overCurrentContext
                sendMsgVC.modalTransitionStyle = .flipHorizontal
                sendMsgVC.isFromMsg = true
                sendMsgVC.objAddDetailData = AddsHandler.sharedInstance.objAddDetails
                sendMsgVC.ad_id = adDetailDataObj.id ?? 0
                sendMsgVC.delegate = self
                present(sendMsgVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func callBtnAction(_ button: UIButton)
    {
        if let phoneURL = URL(string: String(format: "tel://%@", phone))
        {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func whatsappBtnAction(_ button: UIButton)
    {
        let whatsappURL = URL(string: String(format: "https://wa.me/%@", phone))
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
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
            let alert = Constants.showBasicAlert(message: error.message)
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
        return "\(year) years ago"
    }
    
    if let year = components.year, year >= 1 {
        return "Last year"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }
    
    if let month = components.month, month >= 1 {
        return "Last month"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }
    
    if let day = components.day, day >= 1 {
        return "Yesterday"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "Today"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "Today"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "Today"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "Today"
    }
    
    if let second = components.second, second >= 3 {
        return "Today"
    }
    
    return "Today"
    
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
