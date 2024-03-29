//
//  AdPostImageArray.swift
//  PalmTree
//
//  Created by SprintSols on 4/27/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostImageArray {
    
    var imgId : Int!
    var thumb : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init () {
        
    }
    
    
    init(fromDictionary dictionary: [String:Any]){
        imgId = dictionary["img_id"] as? Int
        thumb = dictionary["thumb"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if imgId != nil{
            dictionary["img_id"] = imgId
        }
        if thumb != nil{
            dictionary["thumb"] = thumb
        }
        return dictionary
    }
    
}
