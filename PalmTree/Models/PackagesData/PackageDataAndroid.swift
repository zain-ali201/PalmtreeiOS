//
//  PackageDataAndroid.swift
//  PalmTree
//
//  Created by SprintSols on 6/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct PackageDataAndroid {
    
    var inAppOn : Bool!
    var message : PackageDataMessage!
    var secretCode : String!
    var titleText : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        inAppOn = dictionary["in_app_on"] as? Bool
        if let messageData = dictionary["message"] as? [String:Any] {
            message = PackageDataMessage(fromDictionary: messageData)
        }
        secretCode = dictionary["secret_code"] as? String
        titleText = dictionary["title_text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if inAppOn != nil{
            dictionary["in_app_on"] = inAppOn
        }
        if message != nil{
            dictionary["message"] = message.toDictionary()
        }
        if secretCode != nil{
            dictionary["secret_code"] = secretCode
        }
        if titleText != nil{
            dictionary["title_text"] = titleText
        }
        return dictionary
    }
    
}
