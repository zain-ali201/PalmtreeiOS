//
//  SettingsFeaturedScroll.swift
//  PalmTree
//
//  Created by SprintSols on 3/31/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsFeaturedScroll{
    
    var duration : String!
    var loop : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        duration = dictionary["duration"] as? String
        loop = dictionary["loop"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if duration != nil{
            dictionary["duration"] = duration
        }
        if loop != nil{
            dictionary["loop"] = loop
        }
        return dictionary
    }
    
}
