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
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblFeatured: UILabel!
    @IBOutlet weak var lblFeaturedDescp: UILabel!
    @IBOutlet weak var lblUrgent: UILabel!
    @IBOutlet weak var lblUrgentText: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var packageView: UIView!
    
    var amount = ""
    var days = ""
    var fromVC = ""
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
            lblPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFeatured.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblFeaturedDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUrgent.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblUrgentText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblHeading.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnSkip.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            packageView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        }
        
        lblName.text = adDetailObj.adTitle
        lblDescp.text = adDetailObj.adDesc
        lblPrice.text = "AED "+adDetailObj.adPrice
        
        if fromVC == "myads"
        {
            btnSkip.alpha = 0
            if adDetailObj.adImages.count > 0
            {
                if let imgUrl = URL(string: String(format: "%@%@", Constants.URL.imagesUrl, adDetailObj.adImages[0].url.encodeUrl())) {
                    imgView.setImage(from: imgUrl)
                }
            }
        }
        else
        {
            btnSkip.alpha = 1
            if adDetailObj.images.count > 0
            {
                imgView.image = adDetailObj.images[0]
            }
        }
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
        addPostLiveAPI()
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
            checkoutVC.fromVC = fromVC
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
            "user_id": String(format: "%d", userDetail?.id ?? 0),
            "phone": adDetailObj.phone,
            "whatsapp": adDetailObj.whatsapp,
            "latitude": "0",
            "longitude": "0",
            "country": adDetailObj.location.country,
            "address": adDetailObj.location.address,
            "is_featured": "0",
            "name": adDetailObj.adTitle,
            "price" : adDetailObj.adPrice,
            "price_type" : adDetailObj.priceType,
            "title": adDetailObj.adTitle,
            "description" : adDetailObj.adDesc,
            "status" : "1",
            "cat_id" : String(format: "%d", adDetailObj.subcatID > 0 ? adDetailObj.subcatID : adDetailObj.catID)
        ]
        
        var customDictionary: [String: Any] = [String: Any]()

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


        if customDictionary.count > 0
        {
            let custom = Constants.json(from: customDictionary)
            let param: [String: Any] = ["custom_fields": custom!]
            parameter.merge(with: param)
        }
        print(parameter)
        
        self.showLoader()
        self.uploadAdWithImages(param: parameter as NSDictionary, images: adDetailObj.images)
    }
    
    func uploadAdWithImages(param: NSDictionary, images: [UIImage])
    {
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            
            self.stopAnimating()
            if successResponse.success
            {
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
    
    func adPostUploadImages(parameter: NSDictionary, imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.adPostLive
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            
        }, success: { (successResponse) in
            
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
