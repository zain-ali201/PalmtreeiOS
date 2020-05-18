//
//  AddDetailRating.swift
//  PalmTree
//
//  Created by SprintSols on 4/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailRating {
    
    var canReply : Bool!
    var currentPage : Int!
    var hasReply : Bool!
    var ratingAuthor : String!
    var ratingAuthorImage : String!
    var ratingAuthorName : String!
    var ratingDate : String!
    var ratingId : String!
    var ratingStars : String!
    var ratingText : String!
    var reply : [AddDetailReply]!
    var replyText : String!
    
    var adReactions : AddDetailReactions!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adReactionsData = dictionary["ad_reactions"] as? [String:Any]{
            adReactions = AddDetailReactions(fromDictionary: adReactionsData)
        }
        canReply = dictionary["can_reply"] as? Bool
        currentPage = dictionary["current_page"] as? Int
        hasReply = dictionary["has_reply"] as? Bool
        ratingAuthor = dictionary["rating_author"] as? String
        ratingAuthorImage = dictionary["rating_author_image"] as? String
        ratingAuthorName = dictionary["rating_author_name"] as? String
        ratingDate = dictionary["rating_date"] as? String
        ratingId = dictionary["rating_id"] as? String
        ratingStars = dictionary["rating_stars"] as? String
        ratingText = dictionary["rating_text"] as? String
        reply = [AddDetailReply]()
        if let replyArray = dictionary["reply"] as? [[String:Any]]{
            for dic in replyArray{
                let value = AddDetailReply(fromDictionary: dic)
                reply.append(value)
            }
        }
        replyText = dictionary["reply_text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adReactions != nil{
            dictionary["ad_reactions"] = adReactions.toDictionary()
        }
        if canReply != nil{
            dictionary["can_reply"] = canReply
        }
        if currentPage != nil{
            dictionary["current_page"] = currentPage
        }
        if hasReply != nil{
            dictionary["has_reply"] = hasReply
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
        if ratingStars != nil{
            dictionary["rating_stars"] = ratingStars
        }
        if ratingText != nil{
            dictionary["rating_text"] = ratingText
        }
        if reply != nil{
            var dictionaryElements = [[String:Any]]()
            for replyElement in reply {
                dictionaryElements.append(replyElement.toDictionary())
            }
            dictionary["reply"] = dictionaryElements
        }
        if replyText != nil{
            dictionary["reply_text"] = replyText
        }
        return dictionary
    }
    
}
