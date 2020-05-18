//
//  HomeSlider.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeSlider {
    
    var catId : Int!
    var data : [HomeAdd]!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        catId = dictionary["cat_id"] as? Int
        data = [HomeAdd]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            for dic in dataArray{
                let value = HomeAdd(fromDictionary: dic)
                data.append(value)
            }
        }
        name = dictionary["name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if catId != nil{
            dictionary["cat_id"] = catId
        }
        if data != nil{
            var dictionaryElements = [[String:Any]]()
            for dataElement in data {
                dictionaryElements.append(dataElement.toDictionary())
            }
            dictionary["data"] = dictionaryElements
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
}
