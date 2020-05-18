//
//  SettingsGpsPopup.swift
//  PalmTree
//
//  Created by SprintSols on 3/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsGpsPopup {
    
  
    var btnCancel : String!
    var btnConfirm : String!
    var text : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnConfirm = dictionary["btn_confirm"] as? String
        text = dictionary["text"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btnCancel != nil{
            dictionary["btn_cancel"] = btnCancel
        }
        if btnConfirm != nil{
            dictionary["btn_confirm"] = btnConfirm
        }
        if text != nil{
            dictionary["text"] = text
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
