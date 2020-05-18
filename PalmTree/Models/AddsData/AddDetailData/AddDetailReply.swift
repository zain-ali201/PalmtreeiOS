//
//  AddDetailReply.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailReply {
    
    var canReply : Bool!
    var currentPage : Int!
    var ratingAuthor : String!
    var ratingAuthorImage : String!
    var ratingAuthorName : String!
    var ratingDate : String!
    var ratingId : String!
    var ratingText : String!
    var ratingUserStars : String!
    var replyText : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        canReply = dictionary["can_reply"] as? Bool
        currentPage = dictionary["current_page"] as? Int
        ratingAuthor = dictionary["rating_author"] as? String
        ratingAuthorImage = dictionary["rating_author_image"] as? String
        ratingAuthorName = dictionary["rating_author_name"] as? String
        ratingDate = dictionary["rating_date"] as? String
        ratingId = dictionary["rating_id"] as? String
        ratingText = dictionary["rating_text"] as? String
        ratingUserStars = dictionary["rating_user_stars"] as? String
        replyText = dictionary["reply_text"] as? String
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
        if currentPage != nil{
            dictionary["current_page"] = currentPage
        }
        if ratingAuthor != nil{
            dictionary["rating_author"] = ratingAuthor
        }
        if ratingAuthorImage != nil{
            dictionary["rating_author_image"] = ratingAuthorImage
        }
        if ratingAuthorName != nil{
            dictionary["rating_author_name"] = ratingAuthorName
        }
        if ratingDate != nil{
            dictionary["rating_date"] = ratingDate
        }
        if ratingId != nil{
            dictionary["rating_id"] = ratingId
        }
        if ratingText != nil{
            dictionary["rating_text"] = ratingText
        }
        if ratingUserStars != nil{
            dictionary["rating_user_stars"] = ratingUserStars
        }
        if replyText != nil{
            dictionary["reply_text"] = replyText
        }
        return dictionary
    }
    
}
