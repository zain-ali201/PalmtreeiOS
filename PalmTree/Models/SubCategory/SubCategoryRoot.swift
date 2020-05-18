//
//  SubCategoryRoot.swift
//  PalmTree
//
//  Created by SprintSols on 5/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SubCategoryRoot{
    
    var data : SubCategoryData!
    var message : String!
    var success : Bool!
    var isBid : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = SubCategoryData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
        isBid = dictionary["bid_check"] as? Bool
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
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
