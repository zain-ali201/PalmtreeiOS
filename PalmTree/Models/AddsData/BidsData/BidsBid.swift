
//
//  BidsBid.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BidsBid {
  
    var bidBy : String!
    var comment : String!
    var date : String!
    var name : String!
    var phone : String!
    var price : BidsPrice!
    var profile : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bidBy = dictionary["bid_by"] as? String
        comment = dictionary["comment"] as? String
        date = dictionary["date"] as? String
        name = dictionary["name"] as? String
        phone = dictionary["phone"] as? String
        if let priceData = dictionary["price"] as? [String:Any]{
            price = BidsPrice(fromDictionary: priceData)
        }
        profile = dictionary["profile"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bidBy != nil{
            dictionary["bid_by"] = bidBy
        }
        if comment != nil{
            dictionary["comment"] = comment
        }
        if date != nil{
            dictionary["date"] = date
        }
        if name != nil{
            dictionary["name"] = name
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if price != nil{
            dictionary["price"] = price.toDictionary()
        }
        if profile != nil{
            dictionary["profile"] = profile
        }
        return dictionary
    }
    
}
