//
//  CheckoutViewController.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Stripe
import NVActivityIndicatorView
import Alamofire

class CheckoutViewController: UIViewController, NVActivityIndicatorViewable
{
    var fromVC = ""
    var amount = ""
    var paymentIntentClientSecret: String?

    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()

    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Pay now", for: .normal)
        button.addTarget(self, action: #selector(getClientSecret), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        Stripe.setDefaultPublishableKey(stripeAPIKey)

        let stackView = UIStackView(arrangedSubviews: [cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraintEqualToSystemSpacingAfter(view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraintEqualToSystemSpacingAfter(stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90)
        ])
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

    func displayAlert(title: String, message: String, restartDemo: Bool = false)
    {
        DispatchQueue.main.async {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel))
          self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- API Call
    @objc func getClientSecret()
    {
        let payment = Double(amount)! * 100
        let param: [String: Any] = ["payment": payment]
        
        self.showLoader()
        UserHandler.getClientSecret(parameter: param as NSDictionary , success: { (successResponse) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if successResponse.success {
                self.paymentIntentClientSecret = successResponse.data
                self.pay()
            }
            else {
                self.stopAnimating()
                let alert = Constants.showBasicAlert(message: "Something went wrong. Please try again")
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    func pay()
    {
        
        // Collect card details
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)

        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret!)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status)
            {
                case .failed:
                    self.stopAnimating()
                    self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                    break
                case .canceled:
                    self.stopAnimating()
//                  self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                    break
                case .succeeded:
                    if self.fromVC == "myads"
                    {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-YYYY"

                        let parameter: [String: Any] = [
                            "ad_id": adDetailObj.adId,
                            "featured_date": formatter.string(from: Date())
                        ]
                        self.featureAd(param: parameter as NSDictionary)
                    }
                    else
                    {
                        self.addPostLiveAPI()
                    }
                    break
                @unknown default:
                  fatalError()
                  break
            }
        }
    }
    
    //MARK:- Ad Post APIs
    func addPostLiveAPI()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        
        var parameter: [String: Any] = [
            "user_id": String(format: "%d", userDetail?.id ?? 0),
            "phone": adDetailObj.phone,
            "whatsapp": adDetailObj.whatsapp,
            "latitude": String(format: "%f", userDetail?.lat ?? String(format: "%f", latitude)),
            "longitude": String(format: "%f",userDetail?.lng ?? String(format: "%f", longitude)),
            "country": adDetailObj.location.country,
            "address": adDetailObj.location.address,
            "is_featured": "1",
            "featured_date": formatter.string(from: Date()).english,
            "name": adDetailObj.adTitle,
            "price" : adDetailObj.adPrice,
            "price_type" : adDetailObj.priceType,
            "title": adDetailObj.adTitle,
            "description" : adDetailObj.adDesc,
            "status" : "1",
            "cat_id" : String(format: "%d", adDetailObj.subcatID > 0 ? adDetailObj.subcatID : adDetailObj.catID),
            "parent_cat_id" : String(format: "%d", adDetailObj.catID)
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
        
        self.uploadAdWithImages(param: parameter as NSDictionary, images: adDetailObj.images)
    }
    
    func uploadAdWithImages(param: NSDictionary, images: [UIImage]) {
        self.showLoader()
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
    
    func featureAd(param: NSDictionary)
    {
        self.showLoader()
        AddsHandler.featureAd(param: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
//                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
//
//                })
//                self.presentVC(alert)
                self.navigationController?.popToViewController(myAdsVC, animated: true)
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
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
}

extension CheckoutViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
      return self
    }
}
