//
//  PaymentSuccessController.swift
//  PalmTree
//
//  Created by SprintSols on 10/9/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PaymentSuccessController: UIViewController , UIScrollViewDelegate, NVActivityIndicatorViewable, UIWebViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var scrollBar: UIScrollView! {
        didSet {
            scrollBar.delegate = self
            scrollBar.isScrollEnabled = true
            scrollBar.showsVerticalScrollIndicator = true
        }
    }
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblResponse: UILabel!
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
            webView.isOpaque = false
            webView.backgroundColor = UIColor.white
        }
    }
    
    //MARK:- Properties
    var dataArray = [PaymentSuccessData]()
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleAnalytics(controllerName: "Payment Success Controller")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.adForest_paymentSuccessData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollBar.contentSize = CGSize(width: self.view.frame.width, height: 1200)
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_populateData() {
        if dataArray.isEmpty {
        } else {
            for items in dataArray {
                if let responseText = items.orderThankyouTitle {
                    self.lblResponse.text = responseText
                }
                if let webViewData = items.data {
                    self.webView.loadHTMLString(webViewData, baseURL: nil)
                }
            }
        }
    }
    
    //to set webview size with amount of data
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
    }
    
    
    //MARK:- IBActions
    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.dismissVC {
        }
    }
    
    //MARK:- API Call
    func adForest_paymentSuccessData() {
        self.showLoader()
        UserHandler.paymentSuccess(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.dataArray = [successResponse.data]
                self.adForest_populateData()
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
    
}

