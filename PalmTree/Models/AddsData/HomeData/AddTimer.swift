//
//  AddTimer.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddTimer{
    
    var isShow : Bool!
    var timer : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        timer = dictionary["timer_time"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if timer != nil{
            dictionary["timer_time"] = timer
        }
        return dictionary
    }
    
}
