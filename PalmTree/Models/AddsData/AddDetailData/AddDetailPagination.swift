//
//  AddDetailPagination.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailPagination {
    
    var hasNextPage : Bool!
    var nextPage : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        hasNextPage = dictionary["has_next_page"] as? Bool
        nextPage = dictionary["next_page"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if hasNextPage != nil{
            dictionary["has_next_page"] = hasNextPage
        }
        if nextPage != nil{
            dictionary["next_page"] = nextPage
        }
        return dictionary
    }
    
}
