//
//  AdPostLiveData.swift
//  PalmTree
//
//  Created by SprintSols on 5/2/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostLiveData{
    
    var adId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adId = dictionary["ad_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        return dictionary
    }
    
}
