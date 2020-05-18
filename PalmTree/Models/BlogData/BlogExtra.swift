//
//  BlogExtra.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogExtra {
    
    var commentForm : BlogCommentForm!
    var commentTitle : String!
    var loadMore : String!
    var pageTitle : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let commentFormData = dictionary["comment_form"] as? [String:Any]{
            commentForm = BlogCommentForm(fromDictionary: commentFormData)
        }
        commentTitle = dictionary["comment_title"] as? String
        loadMore = dictionary["load_more"] as? String
        pageTitle = dictionary["page_title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if commentForm != nil{
            dictionary["comment_form"] = commentForm.toDictionary()
        }
        if commentTitle != nil{
            dictionary["comment_title"] = commentTitle
        }
        if loadMore != nil{
            dictionary["load_more"] = loadMore
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        return dictionary
    }
    
}
