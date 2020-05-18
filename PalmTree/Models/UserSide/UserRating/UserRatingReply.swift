//
//  UserRatingReply.swift
//  PalmTree
//
//  Created by SprintSols on 4/3/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserRatingReply {
    
    var canReply : Bool!
    var comments : String!
    var date : String!
    var hasReply : Bool!
    var img : String!
    var name : String!
    var replyTxt : String!
    var stars : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        canReply = dictionary["can_reply"] as? Bool
        comments = dictionary["comments"] as? String
        date = dictionary["date"] as? String
        hasReply = dictionary["has_reply"] as? Bool
        img = dictionary["img"] as? String
        name = dictionary["name"] as? String
        replyTxt = dictionary["reply_txt"] as? String
        stars = dictionary["stars"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if canReply != nil{
            dictionary["can_reply"] = canReply
        }
        if comments != nil{
            dictionary["comments"] = comments
        }
        if date != nil{
            dictionary["date"] = date
        }
        if hasReply != nil{
            dictionary["has_reply"] = hasReply
        }
        if img != nil{
            dictionary["img"] = img
        }
        if name != nil{
            dictionary["name"] = name
        }
        if replyTxt != nil{
            dictionary["reply_txt"] = replyTxt
        }
        if stars != nil{
            dictionary["stars"] = stars
        }
        return dictionary
    }
    
}
