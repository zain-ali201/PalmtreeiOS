//
//  AddDetailIsFeatured.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailIsFeatured{
    
    var isShow : Bool!
    var notification : AddDetailNotification!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        if let notificationData = dictionary["notification"] as? [String:Any]{
            notification = AddDetailNotification(fromDictionary: notificationData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if notification != nil{
            dictionary["notification"] = notification.toDictionary()
        }
        return dictionary
    }
    
}
