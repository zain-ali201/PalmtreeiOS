//
//  BidsController.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class BidsController: ButtonBarPagerTabStripViewController, NVActivityIndicatorViewable {
    
    //MARK:- Properties
    
    var adID = 0
    
    override func viewDidLoad() {
        self.customizePagerTabStrip()
        super.viewDidLoad()
        self.showBackButton()
        self.adMob()
        let param: [String: Any] = ["ad_id": adID]
        print(param)
        self.adForest_bidsData(param: param as NSDictionary)
    }
    
    func customizePagerTabStrip() {
        settings.style.buttonBarBackgroundColor = .white
        var colorString = ""
        if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
            colorString = mainColor
        }
        settings.style.buttonBarItemBackgroundColor = Constants.hexStringToUIColor(hex: colorString)
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0.0
        settings.style.buttonBarItemTitleColor = UIColor.red
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .white
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let SB = UIStoryboard(name: "Main", bundle: nil)
        
        let bids = SB.instantiateViewController(withIdentifier: "Bids") as! Bids
        let stats = SB.instantiateViewController(withIdentifier: "Stats") as! Stats
        
        let childVC = [bids, stats]
        return childVC
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adMob() {
        if UserHandler.sharedInstance.objAdMob != nil {
            let objData = UserHandler.sharedInstance.objAdMob
            var isShowAd = false
            if let adShow = objData?.show {
                isShowAd = adShow
            }
            if isShowAd {
                var isShowBanner = false
                var isShowInterstital = false
                if let banner = objData?.isShowBanner {
                    isShowBanner = banner
                }
                if let intersitial = objData?.isShowInitial {
                    isShowInterstital = intersitial
                }
                if isShowBanner {
                    SwiftyAd.shared.setup(withBannerID: (objData?.bannerId)!, interstitialID: "", rewardedVideoID: "")
                   
                    if objData?.position == "top" {

                    }
                    else {
                        SwiftyAd.shared.showBanner(from: self, at: .bottom)
                    }
                }
                if isShowInterstital {
                    SwiftyAd.shared.setup(withBannerID: "", interstitialID: (objData?.interstitalId)!, rewardedVideoID: "")
                    SwiftyAd.shared.showInterstitial(from: self)
                }
            }
        }
    }
    
    //MARK:- API Call
    func adForest_bidsData(param: NSDictionary) {
        self.showLoader()
        AddsHandler.bidsData(param: param, success: { (successResponse) in
            self.stopAnimating()
            print(successResponse)
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                // set title to stats view if no data available
                AddsHandler.sharedInstance.statsNoDataTitle = successResponse.data.noTopBidders
                
                AddsHandler.sharedInstance.objAdBids = successResponse
                AddsHandler.sharedInstance.biddersArray = successResponse.data.bids
                AddsHandler.sharedInstance.TopBiddersArray = successResponse.data.topBidders
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationName.updateBidsStats), object: nil)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
