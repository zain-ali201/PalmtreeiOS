//
//  PhoneVerificationData.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PhoneVerificationData{
    
    var isNumberVerified : Bool!
    var isNumberVerifiedText : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isNumberVerified = dictionary["is_number_verified"] as? Bool
        isNumberVerifiedText = dictionary["is_number_verified_text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isNumberVerified != nil{
            dictionary["is_number_verified"] = isNumberVerified
        }
        if isNumberVerifiedText != nil{
            dictionary["is_number_verified_text"] = isNumberVerifiedText
        }
        return dictionary
    }
    
}
