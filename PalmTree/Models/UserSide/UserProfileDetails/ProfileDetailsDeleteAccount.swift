//
//  ProfileDetailsDeleteAccount.swift
//  PalmTree
//
//  Created by SprintSols on 5/19/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsDeleteAccount {
    
    var btnCancel : String!
    var btnSubmit : String!
    var popuptext : String!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnSubmit = dictionary["btn_submit"] as? String
        popuptext = dictionary["popuptext"] as? String
        text = dictionary["text"] as? String
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
        if btnSubmit != nil{
            dictionary["btn_submit"] = btnSubmit
        }
        if popuptext != nil{
            dictionary["popuptext"] = popuptext
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
