//
//  CatLocation.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CatLocation{
    
    var catId : Int!
    var count : String!
    var img : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        catId = dictionary["cat_id"] as? Int
        count = dictionary["count"] as? String
        img = dictionary["img"] as? String
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if catId != nil{
            dictionary["cat_id"] = catId
        }
        if count != nil{
            dictionary["count"] = count
        }
        if img != nil{
            dictionary["img"] = img
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
}
