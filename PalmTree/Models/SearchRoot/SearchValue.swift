//
//  SearchValue.swift
//  PalmTree
//
//  Created by SprintSols on 5/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SearchValue {
    
    var hasSub : Bool!
    var hasTemplate : Bool!
    var id : String!
    var name : String!
    
    var isSelected: Bool = false
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        hasSub = dictionary["has_sub"] as? Bool
        hasTemplate = dictionary["has_template"] as? Bool
        id = dictionary["id"] as? String
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
