//
//  SubCategoryValue.swift
//  PalmTree
//
//  Created by SprintSols on 5/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SubCategoryValue {
    
    var hasSub : Bool!
    var hasTemplate : Bool!
    var id : Int!
    var name : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        hasSub = dictionary["has_sub"] as? Bool
        hasTemplate = dictionary["has_template"] as? Bool
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if hasSub != nil{
            dictionary["has_sub"] = hasSub
        }
        if hasTemplate != nil{
            dictionary["has_template"] = hasTemplate
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
}

struct SubCategoryObject {

    var hasSub = false
    var id = 0
    var name = ""
    var subCatArray = [SubCategoryObject]()
}
