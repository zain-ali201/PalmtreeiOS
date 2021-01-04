//
//  ProfileUpdateRoot.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileUpdateRoot {

    var message : String!
    var responseCode : String!
    var success : Bool!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
       
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if message != nil{
            dictionary["message"] = message
        }
        
        if responseCode != nil{
            dictionary["responseCode"] = responseCode
        }
        
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
}
