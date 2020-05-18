//
//  BlogPostExtra.swift
//  PalmTree
//
//  Created by SprintSols on 4/20/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogPostExtra {
    
    var message : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
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
        return dictionary
    }
    
}
