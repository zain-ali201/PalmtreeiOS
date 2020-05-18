//
//  AdPostImage.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostImage{
    
    var isShow : Bool!
    var message : String!
    var numbers : Int!
    var isRequired : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        message = dictionary["message"] as? String
        numbers = dictionary["numbers"] as? Int
        isRequired = dictionary ["is_required"] as? String
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
        if message != nil{
            dictionary["message"] = message
        }
        if numbers != nil{
            dictionary["numbers"] = numbers
        }
        if isRequired != nil{
            dictionary["is_required"] = isRequired
        }
        return dictionary
    }
    
}
