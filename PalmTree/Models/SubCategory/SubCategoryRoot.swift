//
//  SubCategoryRoot.swift
//  PalmTree
//
//  Created by SprintSols on 5/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SubCategoryRoot
{
    var categories : [CategoryJSON]!
    var message : String!
    var success : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categories = [CategoryJSON]()
        if let catIconsArray = dictionary["category"] as? [[String:Any]]
        {
            for dic in catIconsArray
            {
                let value = CategoryJSON(fromDictionary: dic)
                categories.append(value)
            }
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if categories != nil
        {
            var dictionaryElements = [[String:Any]]()
            for catIconsElement in categories {
                dictionaryElements.append(catIconsElement.toDictionary())
            }
            dictionary["Category"] = dictionaryElements
        }
        
        if message != nil
        {
            dictionary["message"] = message
        }
        
        if success != nil
        {
            dictionary["success"] = success
        }
        
        return dictionary
    }
    
}
