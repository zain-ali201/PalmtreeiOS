//
//  BlogDetailComment.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogDetailComment {
    
   
    var blogId : Int!
    var canReply : Bool!
    var commentAuthor : String!
    var commentAuthorId : String!
    var commentContent : String!
    var commentDate : String!
    var commentId : String!
    var commentParent : String!
    var hasChilds : Bool!
    var img : String!
    var reply : [BlogDetailReply]!
    var replyBtnText : String!
    var comments : [BlogDetailComment]!
    var pagination : BlogDetailPagination!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        blogId = dictionary["blog_id"] as? Int
        canReply = dictionary["can_reply"] as? Bool
        commentAuthor = dictionary["comment_author"] as? String
        commentAuthorId = dictionary["comment_author_id"] as? String
        commentContent = dictionary["comment_content"] as? String
        commentDate = dictionary["comment_date"] as? String
        commentId = dictionary["comment_id"] as? String
        commentParent = dictionary["comment_parent"] as? String
        hasChilds = dictionary["has_childs"] as? Bool
        img = dictionary["img"] as? String
        reply = [BlogDetailReply]()
        if let replyArray = dictionary["reply"] as? [[String:Any]]{
            for dic in replyArray{
                let value = BlogDetailReply(fromDictionary: dic)
                reply.append(value)
            }
        }
        replyBtnText = dictionary["reply_btn_text"] as? String
        comments = [BlogDetailComment]()
        if let commentsArray = dictionary["comments"] as? [[String:Any]]{
            for dic in commentsArray{
                let value = BlogDetailComment(fromDictionary: dic)
                comments.append(value)
            }
        }
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = BlogDetailPagination(fromDictionary: paginationData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if blogId != nil{
            dictionary["blog_id"] = blogId
        }
        if canReply != nil{
            dictionary["can_reply"] = canReply
        }
        if commentAuthor != nil{
            dictionary["comment_author"] = commentAuthor
        }
        if commentAuthorId != nil{
            dictionary["comment_author_id"] = commentAuthorId
        }
        if commentContent != nil{
            dictionary["comment_content"] = commentContent
        }
        if commentDate != nil{
            dictionary["comment_date"] = commentDate
        }
        if commentId != nil{
            dictionary["comment_id"] = commentId
        }
        if commentParent != nil{
            dictionary["comment_parent"] = commentParent
        }
        if hasChilds != nil{
            dictionary["has_childs"] = hasChilds
        }
        if img != nil{
            dictionary["img"] = img
        }
        if reply != nil{
            var dictionaryElements = [[String:Any]]()
            for replyElement in reply {
                dictionaryElements.append(replyElement.toDictionary())
            }
            dictionary["reply"] = dictionaryElements
        }
        if replyBtnText != nil{
            dictionary["reply_btn_text"] = replyBtnText
        }
        if comments != nil{
            var dictionaryElements = [[String:Any]]()
            for commentsElement in comments {
                dictionaryElements.append(commentsElement.toDictionary())
            }
            dictionary["comments"] = dictionaryElements
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        return dictionary
    }
    
}
