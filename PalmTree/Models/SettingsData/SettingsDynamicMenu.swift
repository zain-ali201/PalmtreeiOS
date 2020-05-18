//
//  SettingsDynamicMenu.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsDynamicMenu {
    
    var array : [String]!
    var icons : [String]!
    var keys : [String]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        array = dictionary["array"] as? [String]
        icons = dictionary["icons"] as? [String]
        keys = dictionary["keys"] as? [String]
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if array != nil{
            dictionary["array"] = array
        }
        if icons != nil{
            dictionary["icons"] = icons
        }
        if keys != nil{
            dictionary["keys"] = keys
        }
        return dictionary
    }
    
}
