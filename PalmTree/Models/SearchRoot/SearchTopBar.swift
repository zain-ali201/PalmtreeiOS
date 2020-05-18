//
//  SearchTopBar.swift
//  PalmTree
//
//  Created by SprintSols on 5/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SearchTopBar{
    
    var sortArr : [SearchSortArray]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        sortArr = [SearchSortArray]()
        if let sortArrArray = dictionary["sort_arr"] as? [[String:Any]]{
            for dic in sortArrArray{
                let value = SearchSortArray(fromDictionary: dic)
                sortArr.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if sortArr != nil{
            var dictionaryElements = [[String:Any]]()
            for sortArrElement in sortArr {
                dictionaryElements.append(sortArrElement.toDictionary())
            }
            dictionary["sort_arr"] = dictionaryElements
        }
        return dictionary
    }
    
}
