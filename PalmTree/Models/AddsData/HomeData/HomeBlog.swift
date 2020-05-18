//
//  HomeBlog.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeBlog {
    
    var cats : [HomeCategory]!
    var comments : Int!
    var date : String!
    var hasImage : Bool!
    var image : String!
    var postId : Int!
    var readMore : String!
    var title : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        cats = [HomeCategory]()
        if let catsArray = dictionary["cats"] as? [[String:Any]]{
            for dic in catsArray{
                let value = HomeCategory(fromDictionary: dic)
                cats.append(value)
            }
        }
        comments = dictionary["comments"] as? Int
        date = dictionary["date"] as? String
        hasImage = dictionary["has_image"] as? Bool
        image = dictionary["image"] as? String
        postId = dictionary["post_id"] as? Int
        readMore = dictionary["read_more"] as? String
        title = dictionary["title"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if cats != nil{
            var dictionaryElements = [[String:Any]]()
            for catsElement in cats {
                dictionaryElements.append(catsElement.toDictionary())
            }
            dictionary["cats"] = dictionaryElements
        }
        if comments != nil{
            dictionary["comments"] = comments
        }
        if date != nil{
            dictionary["date"] = date
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
        if readMore != nil{
            dictionary["read_more"] = readMore
        }
        if title != nil{
            dictionary["title"] = title
        }
        return dictionary
    }
    
}
