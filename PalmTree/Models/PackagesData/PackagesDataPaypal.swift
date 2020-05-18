//
//  PackagesDataPaypal.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackagesDataPaypal {
    
    var agreementUrl : String!
    var apiKey : String!
    var currency : String!
    var merchantName : String!
    var mode : String!
    var privecyUrl : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        agreementUrl = dictionary["agreement_url"] as? String
        apiKey = dictionary["api_key"] as? String
        currency = dictionary["currency"] as? String
        merchantName = dictionary["merchant_name"] as? String
        mode = dictionary["mode"] as? String
        privecyUrl = dictionary["privecy_url"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if agreementUrl != nil{
            dictionary["agreement_url"] = agreementUrl
        }
        if apiKey != nil{
            dictionary["api_key"] = apiKey
        }
        if currency != nil{
            dictionary["currency"] = currency
        }
        if merchantName != nil{
            dictionary["merchant_name"] = merchantName
        }
        if mode != nil{
            dictionary["mode"] = mode
        }
        if privecyUrl != nil{
            dictionary["privecy_url"] = privecyUrl
        }
        return dictionary
    }
    
}
