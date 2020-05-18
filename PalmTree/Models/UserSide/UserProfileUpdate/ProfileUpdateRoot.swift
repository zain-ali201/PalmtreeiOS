//
//  ProfileUpdateRoot.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileUpdateRoot {
    
    var data : ProfileUpdateData!
    var message : String!
    var pageTitle : ProfileUpdatePageTitle!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = ProfileUpdateData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        if let pageTitleData = dictionary["page_title"] as? [String:Any]{
            pageTitle = ProfileUpdatePageTitle(fromDictionary: pageTitleData)
        }
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle.toDictionary()
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
