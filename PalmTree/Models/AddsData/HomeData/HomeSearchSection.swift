//
//  HomeSearchSection.swift
//  PalmTree
//
//  Created by SprintSols on 8/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeSearchSection{
    
    var image : String!
    var isShow : Bool!
    var mainTitle : String!
    var placeholder : String!
    var subTitle : String!
    var isShowLocation :Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        image = dictionary["image"] as? String
        isShow = dictionary["is_show"] as? Bool
        mainTitle = dictionary["main_title"] as? String
        placeholder = dictionary["placeholder"] as? String
        subTitle = dictionary["sub_title"] as? String
        isShowLocation = dictionary["is_show_location"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if image != nil{
            dictionary["image"] = image
        }
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if mainTitle != nil{
            dictionary["main_title"] = mainTitle
        }
        if placeholder != nil{
            dictionary["placeholder"] = placeholder
        }
        if subTitle != nil{
            dictionary["sub_title"] = subTitle
        }
        return dictionary
    }
    
}
