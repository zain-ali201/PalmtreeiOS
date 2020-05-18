//
//  settingsArray.swift
//  AdForest
//
//  Created by Apple on 9/11/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct SettingsArray{
    
    var sellers : String!
    var favAds : String!
    var featuredAds : String!
    var home : String!
    var inactiveAds : String!
    var messages : String!
    var myAds : String!
    var packages : String!
    var profile : String!
    var search : String!
    var shop : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        sellers = dictionary["Sellers"] as? String
        favAds = dictionary["fav_ads"] as? String
        featuredAds = dictionary["featured_ads"] as? String
        home = dictionary["home"] as? String
        inactiveAds = dictionary["inactive_ads"] as? String
        messages = dictionary["messages"] as? String
        myAds = dictionary["my_ads"] as? String
        packages = dictionary["packages"] as? String
        profile = dictionary["profile"] as? String
        search = dictionary["search"] as? String
        shop = dictionary["shop"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if sellers != nil{
            dictionary["Sellers"] = sellers
        }
        if favAds != nil{
            dictionary["fav_ads"] = favAds
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds
        }
        if home != nil{
            dictionary["home"] = home
        }
        if inactiveAds != nil{
            dictionary["inactive_ads"] = inactiveAds
        }
        if messages != nil{
            dictionary["messages"] = messages
        }
        if myAds != nil{
            dictionary["my_ads"] = myAds
        }
        if packages != nil{
            dictionary["packages"] = packages
        }
        if profile != nil{
            dictionary["profile"] = profile
        }
        if search != nil{
            dictionary["search"] = search
        }
        if shop != nil{
            dictionary["shop"] = shop
        }
        return dictionary
    }
    
}
