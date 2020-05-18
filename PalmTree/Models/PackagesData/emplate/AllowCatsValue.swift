//
//  AllowCatsValue.swift
//  PalmTree
//
//  Created by SprintSols on 10/2/20.
//  Copyright © 2019 apple. All rights reserved.
//


import Foundation

struct AllowCatsValue {
    
    var cat_id : String!
    var cat_name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cat_id = dictionary["cat_id"] as? String
        cat_name = dictionary["cat_name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cat_id != nil{
            dictionary["cat_id"] = cat_id
        }
        if cat_name != nil{
            dictionary["cat_name"] = cat_name
        }
        return dictionary
    }
    
}
