//
//  BlogData.swift
//  PalmTree
//
//  Created by SprintSols on 3/29/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct BlogData{
    
    var pagination : BlogPagination!
    var post : [BlogPost]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = BlogPagination(fromDictionary: paginationData)
        }
        post = [BlogPost]()
        if let postArray = dictionary["post"] as? [[String:Any]]{
            for dic in postArray{
                let value = BlogPost(fromDictionary: dic)
                post.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }
        if post != nil{
            var dictionaryElements = [[String:Any]]()
            for postElement in post {
                dictionaryElements.append(postElement.toDictionary())
            }
            dictionary["post"] = dictionaryElements
        }
        return dictionary
    }
    
}
