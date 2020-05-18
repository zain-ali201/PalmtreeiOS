//
//  TimerString.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct TimerString{
    
    var days : String!
    var hurs : String!
    var mins : String!
    var secs : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        days = dictionary["days"] as? String
        hurs = dictionary["hurs"] as? String
        mins = dictionary["mins"] as? String
        secs = dictionary["secs"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if days != nil{
            dictionary["days"] = days
        }
        if hurs != nil{
            dictionary["hurs"] = hurs
        }
        if mins != nil{
            dictionary["mins"] = mins
        }
        if secs != nil{
            dictionary["secs"] = secs
        }
        return dictionary
    }
    
}
