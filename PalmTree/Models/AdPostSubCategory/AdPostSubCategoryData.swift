//
//  AdPostSubCategoryData.swift
//  PalmTree
//
//  Created by SprintSols on 5/8/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostSubCategoryData {
    
    var fieldName : String!
    var fieldType : String!
    var fieldTypeName : String!
    var fieldVal : Bool!
    var hasCatTemplate : Bool!
    var hasPageNumber : String!
    var isRequired : Bool!
    var mainTitle : String!
    var title : String!
    var values : [AdPostSubCategoryValues]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        fieldName = dictionary["field_name"] as? String
        fieldType = dictionary["field_type"] as? String
        fieldTypeName = dictionary["field_type_name"] as? String
        fieldVal = dictionary["field_val"] as? Bool
        hasCatTemplate = dictionary["has_cat_template"] as? Bool
        hasPageNumber = dictionary["has_page_number"] as? String
        isRequired = dictionary["is_required"] as? Bool
        mainTitle = dictionary["main_title"] as? String
        title = dictionary["title"] as? String
        //values = dictionary["values"] as? String
        values = [AdPostSubCategoryValues]()
        if let valuesArray = dictionary["values"] as? [[String:Any]]{
            for dic in valuesArray{
                let value = AdPostSubCategoryValues(fromDictionary: dic)
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
        if hasPageNumber != nil{
            dictionary["has_page_number"] = hasPageNumber
        }
        if isRequired != nil{
            dictionary["is_required"] = isRequired
        }
        if mainTitle != nil{
            dictionary["main_title"] = mainTitle
        }
        if title != nil{
            dictionary["title"] = title
        }
        if values != nil{
            dictionary["values"] = values
        }
        return dictionary
    }
    
}
