//
//  CategoryData.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CategoryData{
 
    var ads : [CategoryAd]!
    var featuredAds : CategoryFeatureAd!
    var sidebar : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        ads = [CategoryAd]()
        if let adsArray = dictionary["ads"] as? [[String:Any]]{
            for dic in adsArray{
                let value = CategoryAd(fromDictionary: dic)
                ads.append(value)
            }
        }
        if let featuredAdsData = dictionary["featured_ads"] as? [String:Any]{
            featuredAds = CategoryFeatureAd(fromDictionary: featuredAdsData)
        }
        sidebar = dictionary["sidebar"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if ads != nil{
            var dictionaryElements = [[String:Any]]()
            for adsElement in ads {
                dictionaryElements.append(adsElement.toDictionary())
            }
            dictionary["ads"] = dictionaryElements
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds.toDictionary()
        }
        if sidebar != nil{
            dictionary["sidebar"] = sidebar
        }
        return dictionary
    }
    
}
