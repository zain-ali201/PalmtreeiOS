//
//  HomeRoot.swift
//  PalmTree
//
//  Created by SprintSols on 4/17/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeRoot
{
    var categories : [CategoryJSON]!
    var adsData : [AdsJSON]!
    var message : String!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        categories = [CategoryJSON]()
        if let catIconsArray = dictionary["Category"] as? [[String:Any]]{
            for dic in catIconsArray{
                let value = CategoryJSON(fromDictionary: dic)
                categories.append(value)
            }
        }
        
        adsData = [AdsJSON]()
        if let catIconsArray = dictionary["ads"] as? [[String:Any]]{
            for dic in catIconsArray{
                let value = AdsJSON(fromDictionary: dic)
                adsData.append(value)
            }
        }
        
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if categories != nil{
            var dictionaryElements = [[String:Any]]()
            for catIconsElement in categories {
                dictionaryElements.append(catIconsElement.toDictionary())
            }
            dictionary["Category"] = dictionaryElements
        }
        
        if adsData != nil{
            var dictionaryElements = [[String:Any]]()
            for catIconsElement in adsData {
                dictionaryElements.append(catIconsElement.toDictionary())
            }
            dictionary["ads"] = dictionaryElements
        }
        
        if message != nil{
            dictionary["message"] = message
        }
        
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
}


struct CategoryJSON
{
    var id : Int!
    var name : String!
    var img_url : String!
    var has_sub : Bool!
    var has_parent : Int!
    var status : Bool!
    var created_at : String!
    var updated_at : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        has_parent = dictionary["has_parent"] as? Int
        name = dictionary["name"] as? String
        img_url = dictionary["img_url"] as? String
        has_sub = dictionary["has_sub"] as? Bool
        status = dictionary["status"] as? Bool
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if has_parent != nil{
            dictionary["has_parent"] = has_parent
        }
        if name != nil{
            dictionary["name"] = name
        }
        if img_url != nil{
            dictionary["img_url"] = img_url
        }
        
        if has_sub != nil{
            dictionary["has_sub"] = has_sub
        }
        
        if status != nil{
            dictionary["status"] = status
        }
        
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        
        if updated_at != nil{
            dictionary["updated_at"] = updated_at
        }
        return dictionary
    }
}

struct AdsJSON
{
    var id : Int!
    var user_id : Int!
    var cat_id : Int!
    var title : String!
    var description : String!
    var latitude : String!
    var longitude : String!
    var address : String!
    var phone : String!
    var whatsapp : String!
    var price : String!
    var price_type : String!
    var is_featured : Bool!
    var status : Bool!
    var created_at : String!
    var updated_at : String!
    var images : [imageJSON]!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        user_id = dictionary["user_id"] as? Int
        cat_id = dictionary["cat_id"] as? Int
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        address = dictionary["address"] as? String
        phone = dictionary["phone"] as? String
        whatsapp = dictionary["whatsapp"] as? String
        price = dictionary["price"] as? String
        price_type = dictionary["price_type"] as? String
        is_featured = dictionary["is_featured"] as? Bool
        status = dictionary["status"] as? Bool
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        
        images = [imageJSON]()
        if let imagesArray = dictionary["images"] as? [[String:Any]]{
            for dic in imagesArray
            {
                let value = imageJSON(fromDictionary: dic)
                images.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if id != nil{
            dictionary["id"] = id
        }
        
        if user_id != nil{
            dictionary["user_id"] = user_id
        }
        
        if cat_id != nil{
            dictionary["cat_id"] = cat_id
        }
        
        if title != nil{
            dictionary["title"] = title
        }
        if description != nil{
            dictionary["description"] = description
        }
        
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        
        if address != nil{
            dictionary["address"] = address
        }
        
        if phone != nil{
            dictionary["phone"] = phone
        }
        
        if whatsapp != nil{
            dictionary["whatsapp"] = whatsapp
        }
        
        if price != nil{
            dictionary["price"] = price
        }
        
        if price_type != nil{
            dictionary["price_type"] = price_type
        }
        
        if is_featured != nil{
            dictionary["is_featured"] = is_featured
        }
        
        if status != nil{
            dictionary["status"] = status
        }
        
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        
        if updated_at != nil{
            dictionary["updated_at"] = updated_at
        }
        return dictionary
    }
}

struct imageJSON
{
    var id : Int!
    var post_id : Int!
    var url : String!
    
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        post_id = dictionary["post_id"] as? Int
        url = dictionary["url"] as? String
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if id != nil{
            dictionary["id"] = id
        }
        
        if post_id != nil{
            dictionary["post_id"] = post_id
        }
        
        if url != nil{
            dictionary["url"] = url
        }
        
        
        return dictionary
    }
}
