//
//  SearchRoot.swift
//  PalmTree
//
//  Created by SprintSols on 5/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SearchRoot {
    
    var data : [SearchData]!
    var extra : SearchExtra!
    var message : String!
    var success : Bool!
    var topbar : SearchTopBar!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        data = [SearchData]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = SearchData(fromDictionary: dic)
                data.append(value)
            }
        }
        if let extraData = dictionary["extra"] as? [String:Any]{
            extra = SearchExtra(fromDictionary: extraData)
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
        if let topbarData = dictionary["topbar"] as? [String:Any]{
            topbar = SearchTopBar(fromDictionary: topbarData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        if extra != nil{
            dictionary["extra"] = extra.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        if topbar != nil{
            dictionary["topbar"] = topbar.toDictionary()
        }
        return dictionary
    }
    
}
