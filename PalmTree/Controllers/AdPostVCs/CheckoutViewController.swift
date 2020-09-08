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
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
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
        startCheckout()
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

    func startCheckout()
    {
    // Create a PaymentIntent as soon as the view loads
        let url = URL(string: stripeBaseURL)!
        let json: [String: Any] = [
          "items": [
              ["id": "xl-shirt"]
          ]
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
          guard let response = response as? HTTPURLResponse,
            response.statusCode == 200,
            let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let clientSecret = json!["clientSecret"] as? String else {
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                self?.displayAlert(title: "Error loading page", message: message)
                return
          }
          print("Created PaymentIntent")
          self?.paymentIntentClientSecret = clientSecret
        })
        task.resume()
    }

    @objc func pay()
    {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return;
        }
        // Collect card details
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status)
            {
                case .failed:
//                  self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                  break
                case .canceled:
//                  self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                  break
                case .succeeded:
                    let param: [String: Any] = ["is_update": ""]
                    print(param)
                    self.adPost(param: param as NSDictionary)
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
            var parameter: [String: Any] = [
                "images_array": adDetailObj.imageIDArray,
                "ad_phone": adDetailObj.phone,
                "ad_location": adDetailObj.location.address,
                "location_lat": adDetailObj.location.lat ?? "",
                "location_long": adDetailObj.location.lng ?? "",
                "ad_country": adDetailObj.location.address,
                "ad_bidding" : adDetailObj.location.address,
                "ad_featured_ad": true,
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

//                    if self.fromVC == "myads"
//                    {
//                        self.addPostLiveAPI()
//                    }
//                    else
//                    {
                        let param: [String: Any] = ["ad_id": AddsHandler.sharedInstance.adPostAdId]
                        print(param)
                        
                        DispatchQueue.main.async {
                            self.uploadImages(param: param as NSDictionary, images: adDetailObj.images)
                        }
//                    }
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
        
        func uploadImages(param: NSDictionary, images: [UIImage]) {
            
            adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

            }, success: { (successResponse) in
                
                //self.stopAnimating()
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

extension CheckoutViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
      return self
    }
}
