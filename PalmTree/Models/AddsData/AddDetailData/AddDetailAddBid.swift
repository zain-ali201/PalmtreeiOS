//
//  AddDetailAddBid.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailAddBid {
    
    var max : AddDetailAdPrice!
    var maxText : String!
    var min : AddDetailAdPrice!
    var minText : String!
    var total : Int!
    var totalText : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let maxData = dictionary["max"] as? [String:Any]{
            max = AddDetailAdPrice(fromDictionary: maxData)
        }
        maxText = dictionary["max_text"] as? String
        if let minData = dictionary["min"] as? [String:Any]{
            min = AddDetailAdPrice(fromDictionary: minData)
        }
        minText = dictionary["min_text"] as? String
        total = dictionary["total"] as? Int
        totalText = dictionary["total_text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if max != nil{
            dictionary["max"] = max.toDictionary()
        }
        if maxText != nil{
            dictionary["max_text"] = maxText
        }
        if min != nil{
            dictionary["min"] = min.toDictionary()
        }
        if minText != nil{
            dictionary["min_text"] = minText
        }
        if total != nil{
            dictionary["total"] = total
        }
        if totalText != nil{
            dictionary["total_text"] = totalText
        }
        return dictionary
    }
    
}
