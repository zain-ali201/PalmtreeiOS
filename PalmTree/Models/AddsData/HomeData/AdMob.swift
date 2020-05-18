//
//  AdMob.swift
//  PalmTree
//
//  Created by SprintSols on 7/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdMob {
    
    var adId : String!
    var bannerId : String!
    var interstitalId : String!
    var isShowBanner : Bool!
    var isShowInitial : Bool!
    var position : String!
    var show : Bool!
    var time : String!
    var timeInitial : String!
    var type : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adId = dictionary["ad_id"] as? String
        bannerId = dictionary["banner_id"] as? String
        interstitalId = dictionary["interstital_id"] as? String
        isShowBanner = dictionary["is_show_banner"] as? Bool
        isShowInitial = dictionary["is_show_initial"] as? Bool
        position = dictionary["position"] as? String
        show = dictionary["show"] as? Bool
        time = dictionary["time"] as? String
        timeInitial = dictionary["time_initial"] as? String
        type = dictionary["type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        if bannerId != nil{
            dictionary["banner_id"] = bannerId
        }
        if interstitalId != nil{
            dictionary["interstital_id"] = interstitalId
        }
        if isShowBanner != nil{
            dictionary["is_show_banner"] = isShowBanner
        }
        if isShowInitial != nil{
            dictionary["is_show_initial"] = isShowInitial
        }
        if position != nil{
            dictionary["position"] = position
        }
        if show != nil{
            dictionary["show"] = show
        }
        if time != nil{
            dictionary["time"] = time
        }
        if timeInitial != nil{
            dictionary["time_initial"] = timeInitial
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}
