//
//  ProfileDetailsPhoneDialogue.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsPhoneDialogue {
    
    var btnCancel : String!
    var btnConfirm : String!
    var btnResend : String!
    var textField : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnConfirm = dictionary["btn_confirm"] as? String
        btnResend = dictionary["btn_resend"] as? String
        textField = dictionary["text_field"] as? String
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
        if btnResend != nil{
            dictionary["btn_resend"] = btnResend
        }
        if textField != nil{
            dictionary["text_field"] = textField
        }
        return dictionary
    }
    
}
