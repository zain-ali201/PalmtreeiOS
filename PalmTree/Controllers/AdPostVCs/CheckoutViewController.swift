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
                  self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                  break
                case .canceled:
                  self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                  break
                case .succeeded:
                //          self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
                let param: [String: Any] = ["is_update": adDetailObj.adId]
                    print(param)
                    self.adPost(param: param as NSDictionary)
                  break
                @unknown default:
                  fatalError()
                  break
            }
        }
    }
    
    func adPost(param: NSDictionary)
    {
        print(param)
        self.showLoader()
        AddsHandler.adPost(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.addPostLiveAPI()
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
    
    func addPostLiveAPI()
    {
        let parameter: [String: Any] = [
            "ad_featured_ad": true
        ]
        
        self.adPostLive(param: parameter as NSDictionary)
    }
    
    func adPostLive(param: NSDictionary)
    {
        self.showLoader()
        AddsHandler.adPostLive(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                
                print(successResponse)
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
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
}

extension CheckoutViewController: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
      return self
    }
}