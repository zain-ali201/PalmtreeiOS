//
//  FirebaseTokenData.swift
//  PalmTree
//
//  Created by SprintSols on 5/23/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct FirebaseTokenData {
    
    var firebaseRegId : String!
    var userId : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        firebaseRegId = dictionary["firebase_reg_id"] as? String
        userId = dictionary["user_id"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if firebaseRegId != nil{
            dictionary["firebase_reg_id"] = firebaseRegId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
}
