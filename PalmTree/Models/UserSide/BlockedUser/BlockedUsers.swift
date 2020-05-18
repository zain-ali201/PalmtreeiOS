//
//  BlockedUsers.swift
//  PalmTree
//
//  Created by SprintSols on 5/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlockedUsers {
    
    var id : String!
    var image : String!
    var location : String!
    var name : String!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        image = dictionary["image"] as? String
        location = dictionary["location"] as? String
        name = dictionary["name"] as? String
        text = dictionary["text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if location != nil{
            dictionary["location"] = location
        }
        if name != nil{
            dictionary["name"] = name
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
