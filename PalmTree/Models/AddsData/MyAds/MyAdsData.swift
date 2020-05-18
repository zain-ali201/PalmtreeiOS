//
//  MyAdsData.swift
//  PalmTree
//
//  Created by SprintSols on 3/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct MyAdsData {
    
    var ads : [MyAdsAd]!
    var pageTitle : String!
    var pagination : MyAdsPagination!
    var profile : MyAdsProfile!
    var text : MyAdsText!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        ads = [MyAdsAd]()
        if let adsArray = dictionary["ads"] as? [[String:Any]]{
            for dic in adsArray{
                let value = MyAdsAd(fromDictionary: dic)
                ads.append(value)
            }
        }
        pageTitle = dictionary["page_title"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = MyAdsPagination(fromDictionary: paginationData)
        }
        if let profileData = dictionary["profile"] as? [String:Any]{
            profile = MyAdsProfile(fromDictionary: profileData)
        }
        if let textData = dictionary["text"] as? [String:Any]{
            text = MyAdsText(fromDictionary: textData)
        }
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
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if profile != nil{
            dictionary["profile"] = profile.toDictionary()
        }
        if text != nil{
            dictionary["text"] = text.toDictionary()
        }
        return dictionary
    }
    
}
