//
//  SettingsMessagesScreen.swift
//  PalmTree
//
//  Created by SprintSols on 4/14/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsMessagesScreen {
    
    var mainTitle : String!
    var receive : String!
    var sent : String!
    var blocked : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        mainTitle = dictionary["main_title"] as? String
        receive = dictionary["receive"] as? String
        sent = dictionary["sent"] as? String
        blocked = dictionary["blocked"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if mainTitle != nil{
            dictionary["main_title"] = mainTitle
        }
        if receive != nil{
            dictionary["receive"] = receive
        }
        if sent != nil{
            dictionary["sent"] = sent
        }
        return dictionary
    }
    
}
