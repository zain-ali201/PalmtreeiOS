//
//  MyAdsRoot.swift
//  PalmTree
//
//  Created by SprintSols on 3/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct MyAdsRoot {
    
    var data : [AdsJSON]!
    var message : String!
    var success : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        data = [AdsJSON]()
        if let adsArray = dictionary["data"] as? [[String:Any]]{
            for dic in adsArray{
                let value = AdsJSON(fromDictionary: dic)
                data.append(value)
            }
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for adElements in data {
                dictionaryElements.append(adElements.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
