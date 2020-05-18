//
//  BlogDetailPost.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogDetailPost{
  
    var authorName : String!
    var cats : [BlogDetailCat]!
    var commentCount : String!
    var commentMesage : String!
    var commentStatus : String!
    var comments : BlogDetailComment!
    var date : String!
    var desc : String!
    var hasComment : Bool!
    var hasImage : Bool!
    var image : String!
    var postId : Int!
    var tags : [AnyObject]!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        authorName = dictionary["author_name"] as? String
        cats = [BlogDetailCat]()
        if let catsArray = dictionary["cats"] as? [[String:Any]]{
            for dic in catsArray{
                let value = BlogDetailCat(fromDictionary: dic)
                cats.append(value)
            }
        }
        commentCount = dictionary["comment_count"] as? String
        commentMesage = dictionary["comment_mesage"] as? String
        commentStatus = dictionary["comment_status"] as? String
        if let commentsData = dictionary["comments"] as? [String:Any]{
            comments = BlogDetailComment(fromDictionary: commentsData)
        }
        date = dictionary["date"] as? String
        desc = dictionary["desc"] as? String
        hasComment = dictionary["has_comment"] as? Bool
        hasImage = dictionary["has_image"] as? Bool
        image = dictionary["image"] as? String
        postId = dictionary["post_id"] as? Int
        tags = dictionary["tags"] as? [AnyObject]
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if authorName != nil{
            dictionary["author_name"] = authorName
        }
        if cats != nil{
            var dictionaryElements = [[String:Any]]()
            for catsElement in cats {
                dictionaryElements.append(catsElement.toDictionary())
            }
            dictionary["cats"] = dictionaryElements
        }
        if commentCount != nil{
            dictionary["comment_count"] = commentCount
        }
        if commentMesage != nil{
            dictionary["comment_mesage"] = commentMesage
        }
        if commentStatus != nil{
            dictionary["comment_status"] = commentStatus
        }
        if comments != nil{
            dictionary["comments"] = comments.toDictionary()
        }
        if date != nil{
            dictionary["date"] = date
        }
        if desc != nil{
            dictionary["desc"] = desc
        }
        if hasComment != nil{
            dictionary["has_comment"] = hasComment
        }
        if hasImage != nil{
            dictionary["has_image"] = hasImage
        }
        if image != nil{
            dictionary["image"] = image
        }
        if postId != nil{
            dictionary["post_id"] = postId
        }
        if tags != nil{
            dictionary["tags"] = tags
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
