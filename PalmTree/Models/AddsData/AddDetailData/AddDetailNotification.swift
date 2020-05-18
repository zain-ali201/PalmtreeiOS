//
//  AddDetailNotification.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailNotification{
    
    var btn : String!
    var link : Int!
    var makeFeature : Bool!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btn = dictionary["btn"] as? String
        link = dictionary["link"] as? Int
        makeFeature = dictionary["make_feature"] as? Bool
        text = dictionary["text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btn != nil{
            dictionary["btn"] = btn
        }
        if link != nil{
            dictionary["link"] = link
        }
        if makeFeature != nil{
            dictionary["make_feature"] = makeFeature
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
