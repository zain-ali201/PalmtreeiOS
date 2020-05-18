//
//  AddDetailShareInfo.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailShareInfo {
    
    var link : String!
    var text : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        link = dictionary["link"] as? String
        text = dictionary["text"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if link != nil{
            dictionary["link"] = link
        }
        if text != nil{
            dictionary["text"] = text
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
