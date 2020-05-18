//
//  SettingsIsShowMenu.swift
//  PalmTree
//
//  Created by SprintSols on 5/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct settingsIsShowMenu{
    
    var blog : Bool!
    var message : Bool!
    var packageField : Bool!
    var settings : Bool!
    var sellers : Bool!
    var shop : Bool!
    var toplocation : Bool!
    var isWpmlActive : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        blog = dictionary["blog"] as? Bool
        message = dictionary["message"] as? Bool
        packageField = dictionary["package"] as? Bool
        sellers = dictionary["sellers"] as? Bool
        shop = dictionary["shop"] as? Bool
        settings = dictionary["settings"] as? Bool
        toplocation = dictionary["is_top_location"] as? Bool
        isWpmlActive = dictionary["is_wpml_active"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if blog != nil{
            dictionary["blog"] = blog
        }
        if message != nil{
            dictionary["message"] = message
        }
        if packageField != nil{
            dictionary["package"] = packageField
        }
        if sellers != nil{
            dictionary["sellers"] = sellers
        }
        if shop != nil{
            dictionary["shop"] = shop
        }
        if settings != nil{
            dictionary["settings"] = settings
        }
        if toplocation != nil{
            dictionary["is_top_location"] = toplocation
        }
        if isWpmlActive != nil{
            dictionary["is_wpml_active"] = isWpmlActive
        }
        return dictionary
    }
    
}
