//
//  MyAdsAdSaved.swift
//  PalmTree
//
//  Created by SprintSols on 3/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct MyAdsAdSaved {
    
    var isSaved : Int!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isSaved = dictionary["is_saved"] as? Int
        text = dictionary["text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isSaved != nil{
            dictionary["is_saved"] = isSaved
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
