//
//  NearByAddSearchLat.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct NearByAddSearchLat {
    
    var max : Double!
    var min : Double!
    var original : Double!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        max = dictionary["max"] as? Double
        min = dictionary["min"] as? Double
        original = dictionary["original"] as? Double
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if max != nil{
            dictionary["max"] = max
        }
        if min != nil{
            dictionary["min"] = min
        }
        if original != nil{
            dictionary["original"] = original
        }
        return dictionary
    }
    
}
