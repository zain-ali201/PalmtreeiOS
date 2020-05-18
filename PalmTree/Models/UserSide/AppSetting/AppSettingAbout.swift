//
//  AppSettingAbout.swift
//  PalmTree
//
//  Created by SprintSols on 9/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AppSettingAbout {
    
    var desc : String!
    var isShow : Bool!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        desc = dictionary["desc"] as? String
        isShow = dictionary["is_show"] as? Bool
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if desc != nil{
            dictionary["desc"] = desc
        }
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
