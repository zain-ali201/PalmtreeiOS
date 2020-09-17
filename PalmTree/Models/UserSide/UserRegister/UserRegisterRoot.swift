//
//  UserRegister.swift
//  PalmTree
//
//  Created by SprintSols on 3/20/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserRegisterRoot{
    
    var data : UserRegisterData!
    var message : String!
    var success : Bool!
    var authToken : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["user"] as? [String:Any] {
            data = UserRegisterData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
        authToken = dictionary["token"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["user"] = data.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        
        if authToken != nil{
            dictionary["token"] = authToken
        }
        return dictionary
    }
    
}
