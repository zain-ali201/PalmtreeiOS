//
//  PackagesDataProductAmount.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackagesDataProductAmount {
    
    var currency : String!
    var value : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        currency = dictionary["currency"] as? String
        value = dictionary["value"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if currency != nil{
            dictionary["currency"] = currency
        }
        if value != nil{
            dictionary["value"] = value
        }
        return dictionary
    }
    
}
