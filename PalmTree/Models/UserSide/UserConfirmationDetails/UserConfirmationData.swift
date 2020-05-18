//
//  UserConfirmationData.swift
//  PalmTree
//
//  Created by SprintSols on 6/1/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserConfirmationData{
    
    var backText : String!
    var bgColor : String!
    var confirmPlaceholder : String!
    var heading : String!
    var logo : String!
    var submitText : String!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        backText = dictionary["back_text"] as? String
        bgColor = dictionary["bg_color"] as? String
        confirmPlaceholder = dictionary["confirm_placeholder"] as? String
        heading = dictionary["heading"] as? String
        logo = dictionary["logo"] as? String
        submitText = dictionary["submit_text"] as? String
        text = dictionary["text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if backText != nil{
            dictionary["back_text"] = backText
        }
        if bgColor != nil{
            dictionary["bg_color"] = bgColor
        }
        if confirmPlaceholder != nil{
            dictionary["confirm_placeholder"] = confirmPlaceholder
        }
        if heading != nil{
            dictionary["heading"] = heading
        }
        if logo != nil{
            dictionary["logo"] = logo
        }
        if submitText != nil{
            dictionary["submit_text"] = submitText
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
