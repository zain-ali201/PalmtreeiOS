//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

import ImageSlideshow

class AdDetailVC: UIViewController
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
    @IBOutlet weak var lblSpecs: UILabel!
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
    @IBOutlet weak var sellerView: UIView!
    @IBOutlet weak var callingView: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    //MARK:- Properties
    
    var adDetailObj: AdDetailObject!
    var adDetailDataObj:AddDetailData?
    var sourceImages = [ImageSource]()
    var inputImages = [InputSource]()
    
    var readFlag = false
    var fromVC = ""
    
    var txtHeight = 0
    
    
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
            lblSpecs.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
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
        
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        if fromVC == "Post"
        {
            if adDetailObj.categoryID != 3
            {
                tabView.removeFromSuperview()
            }
            
            if adDetailObj.sellerType != ""
            {
                sellerView.alpha = 1
            }
            else
            {
                sellerView.alpha = 0
            }
            
            callingView.alpha = 0
            reportView.alpha = 0
            
            lblName.text = adDetailObj.adTitle
            lblPrice.text = adDetailObj.adPrice
            lblLocation.text = adDetailObj.location.address
            lblSummary.text = adDetailObj.adDesc
            lblSpecs.text = adDetailObj.specs
            
            slideshow.activityIndicator = DefaultActivityIndicator()
            slideshow.currentPageChanged = { page in
            }
            
            for image in adDetailObj.images
            {
                let imgSource = ImageSource(image: image)
                sourceImages.append(imgSource)
            }
            
            slideshow.setImageInputs(sourceImages)
            
            if #available(iOS 13.0, *) {
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
                slideshow.addGestureRecognizer(recognizer)
                       sourceImages.removeAll()
            }
            else
            {
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap12))
                slideshow.addGestureRecognizer(recognizer)
                       sourceImages.removeAll()
            }
        }
        else
        {
//            if adDetailDataObj?.adDetail.categoryID != 3
//            {
//                tabView.removeFromSuperview()
//            }
            
            callingView.alpha = 1
            reportView.alpha = 1
            
            lblName.text = adDetailDataObj?.adDetail.adTitle
            lblPrice.text = adDetailDataObj?.adDetail.adPrice.price
            lblLocation.text = adDetailDataObj?.adDetail.location.address
            lblSummary.text = adDetailDataObj?.adDetail.adDesc
            lblSpecs.text = ""
            
            slideshow.activityIndicator = DefaultActivityIndicator()
            slideshow.currentPageChanged = { page in
            }
            
            if let sliderImages = adDetailDataObj?.adDetail.images {
                for image in sliderImages
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
        
        let txtHeight = lblSummary.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
        
        if txtHeight > 85.0
        {
            readBtn.alpha = 1
            height.constant = txtHeight
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: 0, height: 900)
    }
    
    //MARK:- Custom Functions
    
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
    
    func getUserDetail()
    {
        
    }
    
    func populateData()
    {
        if languageCode == "ar"
        {
            lblJoining.text =  (defaults.string(forKey: "joining") ?? "2020") + " مسجل كعضو منذ"
        }
        else
        {
            lblJoining.text =  "Member since " + (defaults.string(forKey: "joining") ?? "2020")
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
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
            
            let txtHeight = lblSpecs.text?.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
            
            if txtHeight > 85.0
            {
                height.constant = txtHeight
            }
        }
    }
    
    @IBAction func chatBtnAction(_ button: UIButton)
    {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @IBAction func callBtnAction(_ button: UIButton)
    {
        if let phoneURL = URL(string: ("tel://0123456789"))
        {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func whatsappBtnAction(_ button: UIButton)
    {
        let whatsappURL = URL(string: "whatsapp://send?text=Hello")
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        }
    }
}
