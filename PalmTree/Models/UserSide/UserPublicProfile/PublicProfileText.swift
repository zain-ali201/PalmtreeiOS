//
//  PublicProfileText.swift
//  PalmTree
//
//  Created by SprintSols on 4/13/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PublicProfileText {
    
    var adType : String!
    var editable : String!
    var showDropdown : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adType = dictionary["ad_type"] as? String
        editable = dictionary["editable"] as? String
        showDropdown = dictionary["show_dropdown"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adType != nil{
            dictionary["ad_type"] = adType
        }
        if editable != nil{
            dictionary["editable"] = editable
        }
        if showDropdown != nil{
            dictionary["show_dropdown"] = showDropdown
        }
        return dictionary
    }
    
}
