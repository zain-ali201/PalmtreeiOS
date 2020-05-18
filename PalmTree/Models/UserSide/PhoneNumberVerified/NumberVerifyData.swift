//
//  NumberVerifyData.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct NumberVerifyData {
    
    var code : Int!
    var resend : NumberVerifyResend!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? Int
        if let resendData = dictionary["resend"] as? [String:Any]{
            resend = NumberVerifyResend(fromDictionary: resendData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if resend != nil{
            dictionary["resend"] = resend.toDictionary()
        }
        return dictionary
    }
    
}
