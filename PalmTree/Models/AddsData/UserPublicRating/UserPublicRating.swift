//
//  UserPublicRating.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserPublicRating {
    
    var metaKey : String!
    var metaValue : String!
    var umetaId : String!
    var userId : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        metaKey = dictionary["meta_key"] as? String
        metaValue = dictionary["meta_value"] as? String
        umetaId = dictionary["umeta_id"] as? String
        userId = dictionary["user_id"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if metaKey != nil{
            dictionary["meta_key"] = metaKey
        }
        if metaValue != nil{
            dictionary["meta_value"] = metaValue
        }
        if umetaId != nil{
            dictionary["umeta_id"] = umetaId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
