//
//  FavouritesVC.swift
//  PalmTree
//
//  Created by SprintSols on 17/5/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

import ImageSlideshow

class PreviewAdVC: UIViewController
{
    //MARK:- Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblListing: UILabel!
    @IBOutlet weak var lblSellerTypeText: UILabel!
    @IBOutlet weak var lblSellerType: UILabel!

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var sellerView: UIView!
    @IBOutlet weak var descpView: UIView!
    @IBOutlet weak var specsView: UIView!
    @IBOutlet weak var shadow: UIImageView!
    @IBOutlet weak var shadow1: UIImageView!
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var descpHeight: NSLayoutConstraint!
    
    //MARK:- Properties
    
    var adDetailObj: AdDetailObject!
    var sourceImages = [ImageSource]()
    
    var txtHeight = 0
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.googleAnalytics(controllerName: "Watchlist Controller")
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblLocation.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblListing.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSellerTypeText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblSellerType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        lblTitle.text = adDetailObj.adTitle
        lblPrice.text = "AED" + adDetailObj.adPrice
        lblLocation.text = adDetailObj.location.address
        
        if adDetailObj.images.count > 0
        {
            slideshow.backgroundColor = UIColor.white
            slideshow.slideshowInterval = 5.0
            slideshow.pageControlPosition = PageControlPosition.insideScrollView
            slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
            slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
            slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
            
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
        
        if adDetailObj.adDesc != ""
        {
            lblDescp.text = adDetailObj.adDesc
            shadow.alpha = 1
            
            let txtHeight = lblDescp.text!.html2AttributedString?.height(withConstrainedWidth: 345) ?? 0
            
            if txtHeight > 85.0
            {
                descpHeight.constant = txtHeight
            }
        }
        else
        {
            shadow.alpha = 0
            descpView.removeFromSuperview()
        }
        
        if adDetailObj.motorCatObj.sellerType != ""
        {
            lblSellerType.text = adDetailObj.motorCatObj.sellerType
        }
        else if adDetailObj.propertyCatObj.sellerType != ""
        {
            lblSellerType.text = adDetailObj.propertyCatObj.sellerType
        }
        else
        {
            shadow1.alpha = 0
            sellerView.removeFromSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createSpecsView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            if specsView != nil
            {
                specsView.removeFromSuperview()
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
    
    //MARK:- IBActions
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
