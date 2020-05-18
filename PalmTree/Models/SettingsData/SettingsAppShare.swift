//
//  SettingsAppShare.swift
//  PalmTree
//
//  Created by SprintSols on 4/14/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SettingsAppShare{
    
    var isShow : Bool!
    var text : String!
    var title : String!
    var url : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        text = dictionary["text"] as? String
        title = dictionary["title"] as? String
        url = dictionary["url"] as? String
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
        if text != nil{
            dictionary["text"] = text
        }
        if title != nil{
            dictionary["title"] = title
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }
    
}
