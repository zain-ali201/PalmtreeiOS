//
//  Splash.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AdPostVC: UIViewController, NVActivityIndicatorViewable
{
    //MARK:- Properties
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescp: UITextView!
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescp: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblPhoto : UILabel!
    @IBOutlet weak var lblCategory : UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    
    var fromVC = ""

    //MARK:- Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if languageCode == "ar"
        {
            self.view.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            txtPrice.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblTitle.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblDescp.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblEmail.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblText.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblPhoto.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            lblCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCancel.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPreview.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnPost.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            btnCategory.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            txtTitle.textAlignment = .right
            txtDescp.textAlignment = .right
            txtPrice.textAlignment = .right
        }
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
    
    //MARK:- IBActions
    
    @IBAction func cancelBtnACtion(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryBtnACtion(_ sender: Any)
    {
        
    }
    
    @IBAction func locationBtnACtion(_ sender: Any)
    {
        
    }
    
    @IBAction func postAdBtnACtion(_ sender: Any)
    {
        let param: [String: Any] = ["is_update": ""]
        print(param)
        self.adPost(param: param as NSDictionary)
        
//        let featuredVC = self.storyboard?.instantiateViewController(withIdentifier: "FeaturedVC") as! FeaturedVC
//        self.navigationController?.pushViewController(featuredVC, animated: true)
    }
    
    //MARK:- Ad Post APIs
    func adPost(param: NSDictionary)
    {
        print(param)
        self.showLoader()
        AddsHandler.adPost(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {

                print(successResponse)
                AddsHandler.sharedInstance.adPostAdId = successResponse.data.adId
                AddsHandler.sharedInstance.objAdPost = successResponse
                
                let parameter: [String: Any] = [
                    "images_array": "",
                    "ad_phone": "+923225582024",
                    "ad_location": "Sialkot Road",
                    "location_lat": "32.1774414",
                    "location_long": "74.2001039",
                    "ad_country": "Pakistan",
                    "ad_featured_ad": true,
                    "ad_id": AddsHandler.sharedInstance.adPostAdId,
                    "ad_bump_ad": true,
                    "name": self.txtTitle.text!,
                    "ad_price" : self.txtPrice.text!,
                    "ad_title": self.txtTitle.text!,
                    "cat_id": 3
                ]
                
                self.adPostLive(param: parameter as NSDictionary)
            }
            else
            {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                  
                })
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adPostLive(param: NSDictionary) {
        self.showLoader()
        AddsHandler.adPostLive(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
                self.presentVC(alert)
                
//                self.imageIdArray.removeAll()
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
    
    func dynamicFields(param: NSDictionary) {
       self.showLoader()
        AddsHandler.adPostDynamicFields(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objAdPostData = successResponse.data.fields
                AddsHandler.sharedInstance.adPostImagesArray = successResponse.data.adImages
                //self.isBidding = successResponse.isBid
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
             //self.isBidding = successResponse.isBid
            
//            if successResponse.isBid == true{
//                 UserDefaults.standard.set(true, forKey: "isBid")
//            }else{
//                UserDefaults.standard.set(false, forKey: "isBid")
//            }
            
             //UserDefaults.standard.set(successResponse.isBid, forKey: "isBid")
            
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
}
