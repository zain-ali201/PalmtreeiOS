//
//  AddDetailLocation.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailLocation {
    
    var address : String!
    var lat : String!
    var longField : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        address = dictionary["address"] as? String
        lat = dictionary["lat"] as? String
        longField = dictionary["long"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if lat != nil{
            dictionary["lat"] = lat
        }
        if longField != nil{
            dictionary["long"] = longField
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
