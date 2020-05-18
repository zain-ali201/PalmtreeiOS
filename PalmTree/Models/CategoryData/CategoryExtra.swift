//
//  CategoryExtra.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CategoryExtra{
    
    var fieldTypeName : String!
    var isShowFeatured : Bool!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        fieldTypeName = dictionary["field_type_name"] as? String
        isShowFeatured = dictionary["is_show_featured"] as? Bool
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if fieldTypeName != nil{
            dictionary["field_type_name"] = fieldTypeName
        }
        if isShowFeatured != nil{
            dictionary["is_show_featured"] = isShowFeatured
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
