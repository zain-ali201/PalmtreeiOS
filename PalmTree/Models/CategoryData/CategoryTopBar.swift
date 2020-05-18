//
//  CategoryTopBar.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CategoryTopBar{

    var countAds : String!
    var sortArr : [CategorySortArray]!
    var sortArrKey : CategorySortArray!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        countAds = dictionary["count_ads"] as? String
        sortArr = [CategorySortArray]()
        if let sortArrArray = dictionary["sort_arr"] as? [[String:Any]]{
            for dic in sortArrArray{
                let value = CategorySortArray(fromDictionary: dic)
                sortArr.append(value)
            }
        }
        if let sortArrKeyData = dictionary["sort_arr_key"] as? [String:Any]{
            sortArrKey = CategorySortArray(fromDictionary: sortArrKeyData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if countAds != nil{
            dictionary["count_ads"] = countAds
        }
        if sortArr != nil{
            var dictionaryElements = [[String:Any]]()
            for sortArrElement in sortArr {
                dictionaryElements.append(sortArrElement.toDictionary())
            }
            dictionary["sort_arr"] = dictionaryElements
        }
        if sortArrKey != nil{
            dictionary["sort_arr_key"] = sortArrKey.toDictionary()
        }
        return dictionary
    }
    
}
