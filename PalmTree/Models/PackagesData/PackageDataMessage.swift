//
//  PackageDataMessage.swift
//  PalmTree
//
//  Created by SprintSols on 6/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackageDataMessage {
    
    var noMarket : String!
    var oneTime : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        noMarket = dictionary["no_market"] as? String
        oneTime = dictionary["one_time"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if noMarket != nil{
            dictionary["no_market"] = noMarket
        }
        if oneTime != nil{
            dictionary["one_time"] = oneTime
        }
        return dictionary
    }
    
}
