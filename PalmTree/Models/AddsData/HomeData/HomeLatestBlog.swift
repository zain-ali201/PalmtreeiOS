//
//  HomeLatestBlog.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeLatestBlog {
    var blogs : [HomeBlog]!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        blogs = [HomeBlog]()
        if let blogsArray = dictionary["blogs"] as? [[String:Any]]{
            for dic in blogsArray{
                let value = HomeBlog(fromDictionary: dic)
                blogs.append(value)
            }
        }
        text = dictionary["text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if blogs != nil{
            var dictionaryElements = [[String:Any]]()
            for blogsElement in blogs {
                dictionaryElements.append(blogsElement.toDictionary())
            }
            dictionary["blogs"] = dictionaryElements
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
