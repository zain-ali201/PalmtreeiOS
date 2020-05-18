//
//  AddDetailCallPopup.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailCallPopup{
    
    var btnCancel : String!
    var btnSend : String!
    var isPhoneVerified : Bool!
    var isPhoneVerifiedText : String!
    var phoneVerification : Bool!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnSend = dictionary["btn_send"] as? String
        isPhoneVerified = dictionary["is_phone_verified"] as? Bool
        isPhoneVerifiedText = dictionary["is_phone_verified_text"] as? String
        phoneVerification = dictionary["phone_verification"] as? Bool
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
        if btnSend != nil{
            dictionary["btn_send"] = btnSend
        }
        if isPhoneVerified != nil{
            dictionary["is_phone_verified"] = isPhoneVerified
        }
        if isPhoneVerifiedText != nil{
            dictionary["is_phone_verified_text"] = isPhoneVerifiedText
        }
        if phoneVerification != nil{
            dictionary["phone_verification"] = phoneVerification
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
