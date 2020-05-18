//
//  AddDetailsBlockUser.swift
//  PalmTree
//
//  Created by SprintSols on 5/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailsBlockUser {
    
    var isShow : Bool!
    var popupCancel : String!
    var popupConfirm : String!
    var popupText : String!
    var popupTitle : String!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        popupCancel = dictionary["popup_cancel"] as? String
        popupConfirm = dictionary["popup_confirm"] as? String
        popupText = dictionary["popup_text"] as? String
        popupTitle = dictionary["popup_title"] as? String
        text = dictionary["text"] as? String
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
        if popupCancel != nil{
            dictionary["popup_cancel"] = popupCancel
        }
        if popupConfirm != nil{
            dictionary["popup_confirm"] = popupConfirm
        }
        if popupText != nil{
            dictionary["popup_text"] = popupText
        }
        if popupTitle != nil{
            dictionary["popup_title"] = popupTitle
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
