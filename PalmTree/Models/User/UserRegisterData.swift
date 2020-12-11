//
//  UserRegisterData.swift
//  PalmTree
//
//  Created by SprintSols on 3/20/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserRegisterData {
    
    var displayName : String!
    var id : Int!
    var phone : String!
    var profileImg : String!
    var userEmail : String!
    var joining : String!
    
    var isAccountConfirm : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        displayName = dictionary["name"] as? String
        id = dictionary["id"] as? Int
        phone = dictionary["phone"] as? String
        profileImg = dictionary["url"] as? String
        joining = dictionary["created_at"] as? String
        userEmail = dictionary["email"] as? String
        
        isAccountConfirm = dictionary["is_account_confirm"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if displayName != nil{
            dictionary["name"] = displayName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if profileImg != nil{
            dictionary["url"] = profileImg
        }
        if userEmail != nil{
            dictionary["email"] = userEmail
        }
        if joining != nil{
            dictionary["created_at"] = joining
        }
        if isAccountConfirm != nil{
            dictionary["is_account_confirm"] = isAccountConfirm
        }
        return dictionary
    }
    
}
