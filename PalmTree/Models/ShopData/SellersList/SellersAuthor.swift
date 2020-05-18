//
//  SellersAuthor.swift
//  PalmTree
//
//  Created by SprintSols on 9/6/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct SellersAuthor{
    
    var authorAddress : String!
    var authorId : Int!
    var authorImg : String!
    var authorName : String!
    var authorRating : String!
    var authorSocial : SellersSocial!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        authorAddress = dictionary["author_address"] as? String
        authorId = dictionary["author_id"] as? Int
        authorImg = dictionary["author_img"] as? String
        authorName = dictionary["author_name"] as? String
        authorRating = dictionary["author_rating"] as? String
        if let authorSocialData = dictionary["author_social"] as? [String:Any]{
            authorSocial = SellersSocial(fromDictionary: authorSocialData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if authorAddress != nil{
            dictionary["author_address"] = authorAddress
        }
        if authorId != nil{
            dictionary["author_id"] = authorId
        }
        if authorImg != nil{
            dictionary["author_img"] = authorImg
        }
        if authorName != nil{
            dictionary["author_name"] = authorName
        }
        if authorRating != nil{
            dictionary["author_rating"] = authorRating
        }
        if authorSocial != nil{
            dictionary["author_social"] = authorSocial.toDictionary()
        }
        return dictionary
    }
    
}
