//
//  AdMobDelegate.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 08/04/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

import GoogleMobileAds

class AdMobDelegate: NSObject, GADInterstitialDelegate {
    
    var interstitialView: GADInterstitial!
    
    func createAd() -> GADInterstitial {
        interstitialView = GADInterstitial(adUnitID: "ca-app-pub-3521346996890484/7679081330")
        interstitialView.delegate = self
        let request = GADRequest()
        interstitialView.load(request)
        return interstitialView
    }
    
    func showAd() {
        if interstitialView != nil {
            if (interstitialView.isReady == true){
                interstitialView.present(fromRootViewController:currentVc)
            } else {
                print("ad wasn't ready")
                interstitialView = createAd()
            }
        } else {
            print("ad wasn't ready")
            interstitialView = createAd()
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Ad Received")
        if ad.isReady {
            interstitialView.present(fromRootViewController: currentVc)
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("Did Dismiss Screen")
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("Will Dismiss Screen")
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("Will present screen")
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("Will leave application")
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Failed to present screen")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError!) {
        print("\(ad) did fail to receive ad with error \(error)")
    }
}
