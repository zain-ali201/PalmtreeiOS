//
//  UpdateImageData.swift
//  PalmTree
//
//  Created by SprintSols on 4/2/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UpdateImageData {
    
    var profileImg : AnyObject!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        profileImg = dictionary["profile_img"] as AnyObject 
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if profileImg != nil{
            dictionary["profile_img"] = profileImg
        }
        return dictionary
    }
    
}
