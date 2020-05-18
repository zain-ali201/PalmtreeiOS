//
//  MyAdsAdCategory.swift
//  PalmTree
//
//  Created by SprintSols on 3/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct MyAdsAdCategory {
    
    var count : Int!
    var id : Int!
    var name : String!
    var slug : String!
    var taxonomy : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        count = dictionary["count"] as? Int
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        slug = dictionary["slug"] as? String
        taxonomy = dictionary["taxonomy"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if count != nil{
            dictionary["count"] = count
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if slug != nil{
            dictionary["slug"] = slug
        }
        if taxonomy != nil{
            dictionary["taxonomy"] = taxonomy
        }
        return dictionary
    }
    
}
