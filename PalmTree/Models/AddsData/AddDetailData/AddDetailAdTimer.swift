//
//  AddDetailAdTimer.swift
//  PalmTree
//
//  Created by SprintSols on 8/31/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailAdTimer{
    
   
    var isShow : Bool!
    var timerArray : [String]!
    var timerServerTime : String!
    var timerTime : String!
    var timer : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        timerArray = dictionary["timer"] as? [String]
        timerServerTime = dictionary["timer_server_time"] as? String
        timerTime = dictionary["timer_time"] as? String
        timer = dictionary["timer"] as? String
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
        if timerArray != nil{
            dictionary["timer"] = timer
        }
        if timerServerTime != nil{
            dictionary["timer_server_time"] = timerServerTime
        }
        if timerTime != nil{
            dictionary["timer_time"] = timerTime
        }
        if timer != nil{
            dictionary["timer"] = timer
        }
        return dictionary
    }
}
