//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class FeaturedVC: UIViewController, NVActivityIndicatorViewable
{
    //MARK:- Properties
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblFeatured: UILabel!
    @IBOutlet weak var lblFeaturedDescp: UILabel!
    @IBOutlet weak var lblUrgent: UILabel!
    @IBOutlet weak var lblUrgentText: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var packageView: UIView!
    
    var amount = ""
    var days = ""
    //MARK:- Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblName.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblType.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFeatured.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFeaturedDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUrgent.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUrgentText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblHeading.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnSkip.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            packageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        if adDetailObj.images.count > 0
        {
            imgView.image = adDetailObj.images[0]
        }
        
        lblName.text = adDetailObj.adTitle
        lblDescp.text = adDetailObj.adDesc
        lblType.text = adDetailObj.location.address
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipBtnACtion(_ sender: Any)
    {
//        adDetailObj = AdDetailObject()
//        let thankyouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
//        self.navigationController?.pushViewController(thankyouVC, animated: true)
        
        let param: [String: Any] = ["is_update": ""]
        print(param)
        self.adPost(param: param as NSDictionary)
    }
    
    @IBAction func clickBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            packageView.alpha = 1
        }
        else
        {
            let checkoutVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
            self.navigationController?.pushViewController(checkoutVC, animated: true)
        }
    }
    
    @IBAction func packageBtnAction(button: UIButton)
    {
        if button.tag == 1001
        {
            amount = "3.9"
            days = "3"
        }
        else if button.tag == 1002
        {
            amount = "5.9"
            days = "5"
        }
        else if button.tag == 1003
        {
            amount = "7.9"
            days = "7"
        }
        
        let checkoutVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.navigationController?.pushViewController(checkoutVC, animated: true)
    }
    
    @IBAction func crossBtnAction(button: UIButton)
    {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        packageView.alpha = 0
    }
    
    //MARK:- Ad Post APIs
        func addPostLiveAPI()
        {
            var parameter: [String: Any] = [
                "images_array": adDetailObj.imageIDArray,
                "ad_phone": adDetailObj.phone,
                "ad_location": adDetailObj.location.address,
                "location_lat": adDetailObj.location.lat ?? "",
                "location_long": adDetailObj.location.lng ?? "",
                "ad_country": adDetailObj.location.address,
                "ad_featured_ad": false,
                "ad_id": AddsHandler.sharedInstance.adPostAdId,
                "ad_bump_ad": true,
                "name": adDetailObj.adTitle,
                "ad_price" : adDetailObj.adPrice,
                "ad_price_type" : adDetailObj.priceType,
                "ad_title": adDetailObj.adTitle,
                "ad_description" : adDetailObj.adDesc,
                "ad_cats1" : adDetailObj.subcatID > 0 ? adDetailObj.subcatID : adDetailObj.catID
            ]
            
            var customDictionary: [String: Any] = [String: Any]()

            if adDetailObj.location.address != ""
            {
                customDictionary.merge(with: ["area" : adDetailObj.location.address])
            }
            
            if adDetailObj.motorCatObj.regNo != ""
            {
                customDictionary.merge(with: ["regNo" : adDetailObj.motorCatObj.regNo])
            }

            if adDetailObj.motorCatObj.sellerType != ""
            {
                customDictionary.merge(with: ["sellerType" : adDetailObj.motorCatObj.sellerType])
            }

            if adDetailObj.motorCatObj.make != ""
            {
                customDictionary.merge(with: ["make" : adDetailObj.motorCatObj.make])
            }

            if adDetailObj.motorCatObj.model != ""
            {
                customDictionary.merge(with: ["model" : adDetailObj.motorCatObj.model])
            }

            if adDetailObj.motorCatObj.year != ""
            {
                customDictionary.merge(with: ["year" : adDetailObj.motorCatObj.year])
            }

            if adDetailObj.motorCatObj.mileage != ""
            {
                customDictionary.merge(with: ["mileage" : adDetailObj.motorCatObj.mileage])
            }

            if adDetailObj.motorCatObj.bodyType != ""
            {
                customDictionary.merge(with: ["bodyType" : adDetailObj.motorCatObj.bodyType])
            }

            if adDetailObj.motorCatObj.fuelType != ""
            {
                customDictionary.merge(with: ["fuelType" : adDetailObj.motorCatObj.fuelType])
            }

            if adDetailObj.motorCatObj.transmission != ""
            {
                customDictionary.merge(with: ["transmission" : adDetailObj.motorCatObj.transmission])
            }

            if adDetailObj.motorCatObj.colour != ""
            {
                customDictionary.merge(with: ["colour" : adDetailObj.motorCatObj.colour])
            }

            if adDetailObj.motorCatObj.engineSize != ""
            {
                customDictionary.merge(with: ["engineSize" : adDetailObj.motorCatObj.engineSize])
            }

            if adDetailObj.propertyCatObj.propertyType != ""
            {
                customDictionary.merge(with: ["propertyType" : adDetailObj.propertyCatObj.propertyType])
            }

            if adDetailObj.propertyCatObj.bedrooms != ""
            {
                customDictionary.merge(with: ["bedrooms" : adDetailObj.propertyCatObj.bedrooms])
            }

            if adDetailObj.propertyCatObj.sellerType != ""
            {
                customDictionary.merge(with: ["psellerType" : adDetailObj.propertyCatObj.sellerType])
            }

            if adDetailObj.whatsapp != ""
            {
                customDictionary.merge(with: ["whatsapp" : adDetailObj.whatsapp])
            }

            if customDictionary.count > 0
            {
                customDictionary.merge(with: ["ad_price" : adDetailObj.adPrice])
                customDictionary.merge(with: ["ad_price_type" : adDetailObj.priceType])

                let custom = Constants.json(from: customDictionary)
                let param: [String: Any] = ["custom_fields": custom!]
                parameter.merge(with: param)
                parameter.merge(with: customDictionary)
            }
                
            self.adPostLive(param: parameter as NSDictionary)
        }
        
        func adPost(param: NSDictionary)
        {
            print(param)
            self.showLoader()
            AddsHandler.adPost(parameter: param, success: { (successResponse) in
    //            self.stopAnimating()
                if successResponse.success {

                    print(successResponse)
                    AddsHandler.sharedInstance.adPostAdId = successResponse.data.adId
                    AddsHandler.sharedInstance.objAdPost = successResponse
                    
                    adDetailObj.adId = AddsHandler.sharedInstance.adPostAdId

                    let param: [String: Any] = ["ad_id": AddsHandler.sharedInstance.adPostAdId]
                    print(param)
                    
                    DispatchQueue.main.async {
                        self.uploadImages(param: param as NSDictionary, images: adDetailObj.images)
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
        
        func adPostLive(param: NSDictionary)
        {
            self.showLoader()
            AddsHandler.adPostLive(parameter: param, success: { (successResponse) in
                self.stopAnimating()
                if successResponse.success {
                    
                    adDetailObj = AdDetailObject()
                    let thankyouVC = self.storyboard?.instantiateViewController(withIdentifier: "ThankyouVC") as! ThankyouVC
                    self.navigationController?.pushViewController(thankyouVC, animated: true)

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
        
        func uploadImages(param: NSDictionary, images: [UIImage])
        {
            adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

            }, success: { (successResponse) in
                
                if successResponse.success
                {
                    for item in successResponse.data.adImages
                    {
                        adDetailObj.imageIDArray.append(item.imgId)
                    }
                }
                else
                {
                    self.stopAnimating()
                    let alert = Constants.showBasicAlert(message: successResponse.message)
                    self.presentVC(alert)
                }
            }) { (error) in
                self.stopAnimating()
                let alert = Constants.showBasicAlert(message: error.message)
                self.presentVC(alert)
            }
        }
        
        func adPostUploadImages(parameter: NSDictionary, imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
            
            let url = Constants.URL.baseUrl+Constants.URL.adPostUploadImages
            print(url)
            NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
                print(uploadProgress)
                
            }, success: { (successResponse) in
                self.addPostLiveAPI()
                let dictionary = successResponse as! [String: Any]
                print(dictionary)
                let objImg = AdPostImagesRoot(fromDictionary: dictionary)
                success(objImg)
            }) { (error) in
                failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
                self.stopAnimating()
            }
        }
        
        func showLoader() {
            self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
        }
}
