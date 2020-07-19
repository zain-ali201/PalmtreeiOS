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

class AdDetailVC: UIViewController, NVActivityIndicatorViewable
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
    
    //MARK:- Properties
    var adDetailDataObj:HomeAdd?
    var imagesArray:[AddDetailImage] = []
    var sourceImages = [ImageSource]()
    var inputImages = [InputSource]()
    
    var readFlag = false
    var fromVC = ""
    
    var txtHeight = 0
    var ad_id = 0
    var phone = ""
    
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
            
            callBtn.setImage(UIImage(named: "Call_ar"), for: .normal)
            chatBtn.setImage(UIImage(named: "Chat_ar"), for: .normal)
        }
        
        getUserDetail()
        populateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: 0, height: 1000)
    }
    
    //MARK:- Custom Functions
    
    func populateData()
    {
        lblName.text = adDetailDataObj?.adTitle
        lblPrice.text = adDetailDataObj?.adPrice.price
        lblLocation.text = adDetailDataObj?.adLocation.address
        lblSummary.text = adDetailDataObj?.adDesc
        lblID.text = String(format: "ID: %i", adDetailDataObj?.adId ?? 0)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        let date = formatter.date(from: adDetailDataObj?.adDate ?? "")
        
        if date != nil
        {
            lblTime.text = timeAgoSince(date!)
        }
//        lblSeller.text = userDetail?.displayName

//        if languageCode == "ar"
//        {
//            lblJoining.text =   "2020 مسجل كعضو منذ"
//        }
//        else
//        {
//            lblJoining.text =  "Member since 2020"
//        }
        
        if tabView != nil
        {
            tabView.removeFromSuperview()
        }
        height.constant = 60
        
        let txtHeight = lblSummary.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
        
        if txtHeight > 60.0
        {
            readBtn.alpha = 1
            height.constant = txtHeight
        }
        
        if phone == ""
        {
            callBtn.isEnabled = false
            whatsappBtn.isEnabled = false
        }
        
        if imagesArray.count > 0
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
        
        for image in imagesArray
        {
            if image.full != nil
            {
                let alamofireSource = AlamofireSource(urlString: image.full)!
                inputImages.append(alamofireSource)
            }
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
        objectsToShare.append(adDetailDataObj?.adTitle as AnyObject)

        if imagesArray.count > 0
        {
            objectsToShare.append(imagesArray[0].full as AnyObject)
        }

        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func locationBtnAction(_ sender: Any)
    {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        mapVC.latitudeStr = adDetailDataObj?.adLocation.lat ?? ""
        mapVC.latitudeStr = adDetailDataObj?.adLocation.longField ?? ""
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func socialBtnAction(_ button: UIButton)
    {
        if button.tag == 1001
        {
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                vc.setInitialText(adDetailDataObj?.adTitle)
                if imagesArray.count > 0
                {
                    vc.add(URL(string: imagesArray[0].full))
                }
                present(vc, animated: true)
            }
        }
        else
        {
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                vc.setInitialText(adDetailDataObj?.adTitle)
                if imagesArray.count > 0
                {
                    vc.add(URL(string: imagesArray[0].full))
                }
                present(vc, animated: true)
            }
        }
    }
    
    @IBAction func favBtnAction(_ sender: Any)
    {
        let parameter: [String: Any] = ["ad_id": adDetailDataObj?.adId ?? 0]
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
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
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
        let whatsappURL = URL(string: String(format: "whatsapp://%@", phone))
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func reportBtnAction(_ button: UIButton)
    {
        let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportController") as! ReportController
        reportVC.modalPresentationStyle = .overCurrentContext
        reportVC.modalTransitionStyle = .crossDissolve
        reportVC.adID = adDetailDataObj?.adId ?? 0
        self.presentVC(reportVC)
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func getUserDetail()
    {
        let parameter: [String: Any] = ["ad_id": adDetailDataObj?.adId ?? 0]
        print(parameter)
        self.addDetail(param: parameter as NSDictionary)
    }
    
     //MARK:- API Call
   func addDetail(param: NSDictionary)
   {
       self.showLoader()
       AddsHandler.addDetails(parameter: param, success: { (successResponse) in
           self.stopAnimating()
           if successResponse.success
           {
                self.imagesArray = successResponse.data.adDetail.images
                self.phone = successResponse.data.adDetail.phone
                self.populateData()
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
        return "\(hour) hours ago"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "An hour ago"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "A minute ago"
    }
    
    if let second = components.second, second >= 3 {
        return "\(second) seconds ago"
    }
    
    return "Just now"
    
}
