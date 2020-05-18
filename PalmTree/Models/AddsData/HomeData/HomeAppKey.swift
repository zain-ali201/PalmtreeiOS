//
//  HomeAppKey.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeAppKey {
    
    var paypal : String!
    var stripe : String!
    var youtube : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        paypal = dictionary["paypal"] as? String
        stripe = dictionary["stripe"] as? String
        youtube = dictionary["youtube"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if paypal != nil{
            dictionary["paypal"] = paypal
        }
        if stripe != nil{
            dictionary["stripe"] = stripe
        }
        if youtube != nil{
            dictionary["youtube"] = youtube
        }
        return dictionary
    }
    
}
