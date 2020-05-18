//
//  BlockedUserData.swift
//  PalmTree
//
//  Created by SprintSols on 5/24/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlockedUserData{
    
    var pageTitle : String!
    var users : [BlockedUsers]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pageTitle = dictionary["page_title"] as? String
        users = [BlockedUsers]()
        if let usersArray = dictionary["users"] as? [[String:Any]]{
            for dic in usersArray{
                let value = BlockedUsers(fromDictionary: dic)
                users.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if users != nil{
            var dictionaryElements = [[String:Any]]()
            for usersElement in users {
                dictionaryElements.append(usersElement.toDictionary())
            }
            dictionary["users"] = dictionaryElements
        }
        return dictionary
    }
    
}
