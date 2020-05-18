//
//  SearchValueDict.swift
//  PalmTree
//
//  Created by Furqan Nadeem on 01/02/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
struct SearchValueDict {
    
    var min : String!
    var max : String!
  
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        min = dictionary["min_val"] as? String
        max = dictionary["max_val"] as? String
      
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if min != nil{
            dictionary["min_val"] = min
        }
        if max != nil{
            dictionary["max_val"] = max
        }
    
        return dictionary
    }
    
}
