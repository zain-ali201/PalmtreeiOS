//
//  SubCategoryData.swift
//  PalmTree
//
//  Created by SprintSols on 5/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SubCategoryData{
    
    var fieldName : String!
    var fieldType : String!
    var fieldTypeName : String!
    var fieldVal : String!
    var hasCatTemplate : Bool!
    var mainTitle : String!
    var title : String!
    var values : [SubCategoryValue]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        fieldName = dictionary["field_name"] as? String
        fieldType = dictionary["field_type"] as? String
        fieldTypeName = dictionary["field_type_name"] as? String
        fieldVal = dictionary["field_val"] as? String
        hasCatTemplate = dictionary["has_cat_template"] as? Bool
        mainTitle = dictionary["main_title"] as? String
        title = dictionary["title"] as? String
        values = [SubCategoryValue]()
        if let valuesArray = dictionary["values"] as? [[String:Any]]{
            for dic in valuesArray{
                let value = SubCategoryValue(fromDictionary: dic)
                values.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if fieldName != nil{
            dictionary["field_name"] = fieldName
        }
        if fieldType != nil{
            dictionary["field_type"] = fieldType
        }
        if fieldTypeName != nil{
            dictionary["field_type_name"] = fieldTypeName
        }
        if fieldVal != nil{
            dictionary["field_val"] = fieldVal
        }
        if hasCatTemplate != nil{
            dictionary["has_cat_template"] = hasCatTemplate
        }
        if mainTitle != nil{
            dictionary["main_title"] = mainTitle
        }
        if title != nil{
            dictionary["title"] = title
        }
        if values != nil{
            var dictionaryElements = [[String:Any]]()
            for valuesElement in values {
                dictionaryElements.append(valuesElement.toDictionary())
            }
            dictionary["values"] = dictionaryElements
        }
        return dictionary
    }
    
}
