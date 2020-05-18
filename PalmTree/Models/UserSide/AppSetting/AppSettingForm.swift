//
//  AppSettingForm.swift
//  PalmTree
//
//  Created by SprintSols on 9/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AppSettingForm {
    
    var btnCancel : String!
    var btnSubmit : String!
    var email : String!
    var message : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnSubmit = dictionary["btn_submit"] as? String
        email = dictionary["email"] as? String
        message = dictionary["message"] as? String
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
        if btnSubmit != nil{
            dictionary["btn_submit"] = btnSubmit
        }
        if email != nil{
            dictionary["email"] = email
        }
        if message != nil{
            dictionary["message"] = message
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
