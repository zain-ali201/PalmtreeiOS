//
//  UserPublicRate.swift
//  PalmTree
//
//  Created by SprintSols on 9/4/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct UserPublicRate{
    
    var canReply : Bool!
    var comments : String!
    var date : String!
    var hasReply : Bool!
    var img : String!
    var name : String!
    var reply : UserPublicReply!
    var replyId : String!
    var replyTxt : String!
    var stars : String!
    
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
        if let replyData = dictionary["reply"] as? [String:Any] {
            reply = UserPublicReply(fromDictionary: replyData)
        }
        replyId = dictionary["reply_id"] as? String
        replyTxt = dictionary["reply_txt"] as? String
        stars = dictionary["stars"] as? String
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
        if reply != nil{
            dictionary["reply"] = reply
        }
        if replyId != nil{
            dictionary["reply_id"] = replyId
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
