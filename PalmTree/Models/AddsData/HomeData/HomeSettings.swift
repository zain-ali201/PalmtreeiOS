//
//  HomeSettings.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeSettings {
    
    var ads : AdMob!
    var analytics : HomeAnalytic!
    var appKey : HomeAppKey!
    var firebase : HomeFirebase!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adsData = dictionary["ads"] as? [String:Any]{
            ads = AdMob(fromDictionary: adsData)
        }
        if let analyticsData = dictionary["analytics"] as? [String:Any]{
            analytics = HomeAnalytic(fromDictionary: analyticsData)
        }
        if let appKeyData = dictionary["appKey"] as? [String:Any]{
            appKey = HomeAppKey(fromDictionary: appKeyData)
        }
        if let firebaseData = dictionary["firebase"] as? [String:Any]{
            firebase = HomeFirebase(fromDictionary: firebaseData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if ads != nil{
            dictionary["ads"] = ads.toDictionary()
        }
        if analytics != nil{
            dictionary["analytics"] = analytics.toDictionary()
        }
        if appKey != nil{
            dictionary["appKey"] = appKey.toDictionary()
        }
        if firebase != nil{
            dictionary["firebase"] = firebase.toDictionary()
        }
        return dictionary
    }
    
}
