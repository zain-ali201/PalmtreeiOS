//
//  UserPublicRatingRoot.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserPublicRatingRoot{
    
    var data : UserPublicRatingData!
    var message : String!
    var ratings : [UserPublicRating]!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = UserPublicRatingData(fromDictionary: dataData)
        }
        message = dictionary["message"] as? String
        ratings = [UserPublicRating]()
        if let ratingsArray = dictionary["ratings"] as? [[String:Any]]{
            for dic in ratingsArray{
                let value = UserPublicRating (fromDictionary: dic)
                ratings.append(value)
            }
        }
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if ratings != nil{
            var dictionaryElements = [[String:Any]]()
            for ratingsElement in ratings {
                dictionaryElements.append(ratingsElement.toDictionary())
            }
            dictionary["ratings"] = dictionaryElements
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
