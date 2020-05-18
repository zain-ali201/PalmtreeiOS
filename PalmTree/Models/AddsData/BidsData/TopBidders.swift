//
//  TopBidders.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct TopBidders {
    
  
    var date : String!
    var name : String!
    var offerBy : String!
    var price : String!
    var profile : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        date = dictionary["date"] as? String
        name = dictionary["name"] as? String
        offerBy = dictionary["offer_by"] as? String
        price = dictionary["price"] as? String
        profile = dictionary["profile"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if date != nil{
            dictionary["date"] = date
        }
        if name != nil{
            dictionary["name"] = name
        }
        if offerBy != nil{
            dictionary["offer_by"] = offerBy
        }
        if price != nil{
            dictionary["price"] = price
        }
        if profile != nil{
            dictionary["profile"] = profile
        }
        return dictionary
    }
    
}
