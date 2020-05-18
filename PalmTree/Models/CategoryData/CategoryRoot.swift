//
//  CategoryRoot.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CategoryRoot {
    
    var data : CategoryData!
    var extra : CategoryExtra!
    var message : String!
    var pagination : CategoryPagination!
    var success : Bool!
    var topbar : CategoryTopBar!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = CategoryData(fromDictionary: dataData)
        }
        if let extraData = dictionary["extra"] as? [String:Any]{
            extra = CategoryExtra(fromDictionary: extraData)
        }
        message = dictionary["message"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = CategoryPagination(fromDictionary: paginationData)
        }
        success = dictionary["success"] as? Bool
        if let topbarData = dictionary["topbar"] as? [String:Any]{
            topbar = CategoryTopBar(fromDictionary: topbarData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if extra != nil{
            dictionary["extra"] = extra.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
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
