//
//  CategoryFeatureAd.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CategoryFeatureAd {
    
    var ads : [CategoryAd]!
    var text : String!
    
    
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
        text = dictionary["text"] as? String
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
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
