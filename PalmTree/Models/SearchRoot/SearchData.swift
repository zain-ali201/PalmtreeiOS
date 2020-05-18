//
//  SearchData.swift
//  PalmTree
//
//  Created by SprintSols on 5/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SearchData {
    
    var title : String!
    var data : [SearchData]!
    var fieldName : String!
    var fieldType : String!
    var fieldTypeName : String!
    var fieldVal : String!
    var hasCatTemplate : Bool!
    var mainTitle : String!
    var values : [SearchValue]!
    var arrFields : [String]!
    var searchValDict : SearchValueDict!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init () {
        
    }
    
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        data = [SearchData]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = SearchData(fromDictionary: dic)
                data.append(value)
            }
        }
        fieldName = dictionary["field_name"] as? String
        fieldType = dictionary["field_type"] as? String
        fieldTypeName = dictionary["field_type_name"] as? String
        fieldVal = dictionary["field_val"] as? String
        hasCatTemplate = dictionary["has_cat_template"] as? Bool
        mainTitle = dictionary["main_title"] as? String
        if let searchValDic = dictionary["values"] as? [String:Any]{
            searchValDict = SearchValueDict(fromDictionary: searchValDic)
        }
      //  values = dictionary["values"] as? String
        values = [SearchValue]()
        if let valuesArray = dictionary["values"] as? [[String:Any]]{
            for dic in valuesArray{
                let value = SearchValue(fromDictionary: dic)
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
        if title != nil{
            dictionary["title"] = title
        }
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
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
//        if values != nil{
//            dictionary["values"] = values
//        }
        
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
