//
//  RejectedAdsText.swift
//  PalmTree
//
//  Created by SprintSols on 9/11/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct RejectedAdsText{
    
    var adType : String!
    var deleteText : String!
    var editText : String!
    var editable : String!
    var showDropdown : String!
    var statusDropdownName : [String]!
    var statusDropdownValue : [String]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adType = dictionary["ad_type"] as? String
        deleteText = dictionary["delete_text"] as? String
        editText = dictionary["edit_text"] as? String
        editable = dictionary["editable"] as? String
        showDropdown = dictionary["show_dropdown"] as? String
        statusDropdownName = dictionary["status_dropdown_name"] as? [String]
        statusDropdownValue = dictionary["status_dropdown_value"] as? [String]
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
        if deleteText != nil{
            dictionary["delete_text"] = deleteText
        }
        if editText != nil{
            dictionary["edit_text"] = editText
        }
        if editable != nil{
            dictionary["editable"] = editable
        }
        if showDropdown != nil{
            dictionary["show_dropdown"] = showDropdown
        }
        if statusDropdownName != nil{
            dictionary["status_dropdown_name"] = statusDropdownName
        }
        if statusDropdownValue != nil{
            dictionary["status_dropdown_value"] = statusDropdownValue
        }
        return dictionary
    }
    
}
