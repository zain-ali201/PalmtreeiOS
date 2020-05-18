//
//  HomeAdpost.swift
//  PalmTree
//
//  Created by SprintSols on 10/24/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
struct HomeAdpost {
    
    var can_post : Bool!
    var verMsg : String!
   
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        can_post = dictionary["can_post"] as? Bool
        verMsg = dictionary["verified_msg"] as? String
  
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if can_post != nil{
            dictionary["can_post"] = can_post
        }
      
        return dictionary
    }
    
}
