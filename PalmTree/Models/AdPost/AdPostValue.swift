//
//  AdPostValue.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostValue {
    
    var hasSub : Bool!
    var hasTemplate : Bool!
    var id : String!
    var isShow : Bool!
    var name : String!
    var isChecked : Bool!
    var tempIsSelected = false
    var isBid : Bool!
    var isPay : Bool!
    var isImg : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        hasSub = dictionary["has_sub"] as? Bool
        hasTemplate = dictionary["has_template"] as? Bool
        id = dictionary["id"] as? String
        isShow = dictionary["is_show"] as? Bool
        name = dictionary["name"] as? String
        isChecked = dictionary["is_checked"] as? Bool
        isBid = dictionary["is_bidding"] as? Bool
        isPay = dictionary["can_post"] as? Bool
        isImg = dictionary["is_bidding"] as? Bool
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
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if name != nil{
            dictionary["name"] = name
        }
        if isChecked != nil{
            dictionary["is_checked"] = isChecked
        }
        return dictionary
    }
    
}
