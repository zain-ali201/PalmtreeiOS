//
//  RejectedAdsTimer.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct RejectedAdsTimer{
    
    var isShow : Bool!
    var timer : String!
    var timerServerTime : String!
    var timerStrings : TimerString!
    var timerTime : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        timer = dictionary["timer"] as? String
        timerServerTime = dictionary["timer_server_time"] as? String
        if let timerStringsData = dictionary["timer_strings"] as? [String:Any]{
            timerStrings = TimerString(fromDictionary: timerStringsData)
        }
        timerTime = dictionary["timer_time"] as? String
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
            dictionary["timer"] = timer
        }
        if timerServerTime != nil{
            dictionary["timer_server_time"] = timerServerTime
        }
        if timerStrings != nil{
            dictionary["timer_strings"] = timerStrings.toDictionary()
        }
        if timerTime != nil{
            dictionary["timer_time"] = timerTime
        }
        return dictionary
    }
    
}
