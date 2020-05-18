//
//  HomeAppTopLocation.swift
//  PalmTree
//
//  Created by SprintSols on 9/16/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct HomeAppTopLocation{
    
    var locationId : String!
    var locationName : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        locationId = dictionary["location_id"] as? String
        locationName = dictionary["location_name"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if locationId != nil{
            dictionary["location_id"] = locationId
        }
        if locationName != nil{
            dictionary["location_name"] = locationName
        }
        return dictionary
    }
    
}
