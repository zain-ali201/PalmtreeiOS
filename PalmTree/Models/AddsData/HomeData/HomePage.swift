//
//  HomePage.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomePage {
    
    var icon : Int!
    var pageId : Int!
    var pageTitle : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        icon = dictionary["icon"] as? Int
        pageId = dictionary["page_id"] as? Int
        pageTitle = dictionary["page_title"] as? String
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
        return dictionary
    }
    
}
