//
//  AddDetailReactions.swift
//  PalmTree
//
//  Created by SprintSols on 9/19/20.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

struct AddDetailReactions{
    
    var angry : String!
    var like : String!
    var love : String!
    var wow : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        angry = dictionary["angry"] as? String
        like = dictionary["like"] as? String
        love = dictionary["love"] as? String
        wow = dictionary["wow"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if angry != nil{
            dictionary["angry"] = angry
        }
        if like != nil{
            dictionary["like"] = like
        }
        if love != nil{
            dictionary["love"] = love
        }
        if wow != nil{
            dictionary["wow"] = wow
        }
        return dictionary
    }
    
}
