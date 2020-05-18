//
//  AdPostPriceTypeData.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostPriceTypeData {
    
    var isShow : Bool!
    var key : String!
    var val : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        key = dictionary["key"] as? String
        val = dictionary["val"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if key != nil{
            dictionary["key"] = key
        }
        if val != nil{
            dictionary["val"] = val
        }
        return dictionary
    }
    
}
