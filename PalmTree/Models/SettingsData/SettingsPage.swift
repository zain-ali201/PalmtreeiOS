//
//  SettingsPage.swift
//  PalmTree
//
//  Created by SprintSols on 3/31/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsPage {
    
    var icon : Int!
    var pageId : Int!
    var pageTitle : String!
    var type : String!
    var url : String!
    var pageUrl: String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        icon = dictionary["icon"] as? Int
        pageId = dictionary["page_id"] as? Int
        pageTitle = dictionary["page_title"] as? String
        type = dictionary["type"] as? String
        url = dictionary["url"] as? String
        pageUrl = dictionary["page_url"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if icon != nil{
            dictionary["icon"] = icon
        }
        if pageId != nil{
            dictionary["page_id"] = pageId
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if type != nil{
            dictionary["type"] = type
        }
        if url != nil{
            dictionary["url"] = url
        }
        if pageUrl != nil {
            dictionary["page_url"] = pageUrl
        }
        return dictionary
    }
}
