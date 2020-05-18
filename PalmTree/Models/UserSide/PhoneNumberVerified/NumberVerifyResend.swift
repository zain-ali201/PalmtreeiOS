//
//  NumberVerifyResend.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct NumberVerifyResend{
    
    var text : String!
    var time : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        text = dictionary["text"] as? String
        time = dictionary["time"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if text != nil{
            dictionary["text"] = text
        }
        if time != nil{
            dictionary["time"] = time
        }
        return dictionary
    }
    
}
