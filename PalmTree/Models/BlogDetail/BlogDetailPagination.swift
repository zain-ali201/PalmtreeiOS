//
//  BlogDetailPagination.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogDetailPagination{
   
    var currentNoOfAds : Int!
    var currentPage : Int!
    var hasNextPage : Bool!
    var increment : Int!
    var maxNumPages : Int!
    var nextPage : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        currentNoOfAds = dictionary["current_no_of_ads"] as? Int
        currentPage = dictionary["current_page"] as? Int
        hasNextPage = dictionary["has_next_page"] as? Bool
        increment = dictionary["increment"] as? Int
        maxNumPages = dictionary["max_num_pages"] as? Int
        nextPage = dictionary["next_page"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if currentNoOfAds != nil{
            dictionary["current_no_of_ads"] = currentNoOfAds
        }
        if currentPage != nil{
            dictionary["current_page"] = currentPage
        }
        if hasNextPage != nil{
            dictionary["has_next_page"] = hasNextPage
        }
        if increment != nil{
            dictionary["increment"] = increment
        }
        if maxNumPages != nil{
            dictionary["max_num_pages"] = maxNumPages
        }
        if nextPage != nil{
            dictionary["next_page"] = nextPage
        }
        return dictionary
    }
    
}
