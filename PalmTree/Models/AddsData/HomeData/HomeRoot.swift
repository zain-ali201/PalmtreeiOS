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
        if let catIconsArray = dictionary["data"] as? [[String:Any]]{
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
            dictionary["data"] = dictionaryElements
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
    var arabicName : String!
    var imgUrl : String!
    var hasSub : String!
    var hasParent : String!
    var status : String!
    var createdAt : String!
    var updatedAt : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        hasParent = dictionary["has_parent"] as? String
        name = dictionary["name"] as? String
        arabicName = dictionary["arabic_name"] as? String
        imgUrl = dictionary["img_url"] as? String
        hasSub = dictionary["has_sub"] as? String
        status = dictionary["status"] as? String
        createdAt = dictionary["created_at"] as? String
        updatedAt = dictionary["updated_at"] as? String
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
        if hasParent != nil{
            dictionary["has_parent"] = hasParent
        }
        if name != nil{
            dictionary["name"] = name
        }
        if arabicName != nil{
            dictionary["arabic_name"] = arabicName
        }
        if imgUrl != nil{
            dictionary["img_url"] = imgUrl
        }
        
        if hasSub != nil{
            dictionary["has_sub"] = hasSub
        }
        
        if status != nil{
            dictionary["status"] = status
        }
        
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
}

struct AdsJSON
{
    var id : Int!
    var userID : Int!
    var catID : Int!
    var catParentID : Int!
    var title : String!
    var description : String!
    var latitude : String!
    var longitude : String!
    var address : String!
    var country : String!
    var phone : String!
    var whatsapp : String!
    var price : String!
    var price_type : String!
    var isFeatured : Bool!
    var isFavorite = false
    var status : Bool!
    var createdAt : String!
    var updatedAt : String!
    var username : String!
    var userjoin : String!
    var email : String!
    var catName : String!
    var catParent : String!
    var chatToken : String!
    var images : [ImageJSON]!
    var customFields : [CustomFieldsJSON]!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        userID = dictionary["user_id"] as? Int
        catID = dictionary["cat_id"] as? Int
        catParentID = dictionary["cat_parent_id"] as? Int
        title = dictionary["title"] as? String
        description = dictionary["description"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        address = dictionary["address"] as? String
        country = dictionary["country"] as? String
        phone = dictionary["phone"] as? String
        whatsapp = dictionary["whatsapp"] as? String
        price = dictionary["price"] as? String
        price_type = dictionary["price_type"] as? String
        isFeatured = dictionary["is_featured"] as? Bool
        isFavorite = dictionary["is_favorite"] as? Bool ?? false
        status = dictionary["status"] as? Bool
        createdAt = dictionary["created_at"] as? String
        updatedAt = dictionary["updated_at"] as? String
        username = dictionary["username"] as? String
        userjoin = dictionary["userjoin"] as? String
        email = dictionary["email"] as? String
        catName = dictionary["cat_name"] as? String
        chatToken = dictionary["fc_token"] as? String
        catParent = dictionary["cat_parent"] as? String
        
        images = [ImageJSON]()
        if let imagesArray = dictionary["images"] as? [[String:Any]]{
            for dic in imagesArray
            {
                let value = ImageJSON(fromDictionary: dic)
                images.append(value)
            }
        }
        
        customFields = [CustomFieldsJSON]()
        if let customFieldsArray = dictionary["custom_fields"] as? [[String:Any]]{
            for dic in customFieldsArray
            {
                let value = CustomFieldsJSON(fromDictionary: dic)
                customFields.append(value)
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
        
        if userID != nil{
            dictionary["user_id"] = userID
        }
        
        if catID != nil{
            dictionary["cat_id"] = catID
        }
        
        if catParentID != nil{
            dictionary["cat_parent_id"] = catParentID
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
        
        if country != nil{
            dictionary["country"] = country
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
        
        if isFeatured != nil{
            dictionary["is_featured"] = isFeatured
        }
        
        if isFavorite != nil{
            dictionary["is_favorite"] = isFavorite
        }
        
        if status != nil{
            dictionary["status"] = status
        }
        
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        
        if username != nil{
            dictionary["username"] = username
        }
        
        if userjoin != nil{
            dictionary["userjoin"] = userjoin
        }
        
        if email != nil{
            dictionary["email"] = email
        }
        
        if catName != nil{
            dictionary["cat_name"] = catName
        }
        
        if catParent != nil{
            dictionary["cat_parent"] = catParent
        }
        
        if chatToken != nil{
            dictionary["fc_token"] = chatToken
        }
        
        if images != nil{
            var dictionaryElements = [[String:Any]]()
            for imageElement in images {
                dictionaryElements.append(imageElement.toDictionary())
            }
            dictionary["images"] = dictionaryElements
        }
        
        if customFields != nil{
            var dictionaryElements = [[String:Any]]()
            for imageElement in customFields {
                dictionaryElements.append(imageElement.toDictionary())
            }
            dictionary["custom_fields"] = dictionaryElements
        }
        
        return dictionary
    }
}

struct ImageRoot
{
    var data : ImageJSON!
    var message : String!
    var success : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        
        data = ImageJSON(fromDictionary: dictionary["data"] as! [String : Any])
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if data != nil{
            dictionary["data"] = data
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

struct ImageJSON
{
    var id : Int!
    var postID : Int!
    var url : String!
    
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        postID = dictionary["post_id"] as? Int
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
        
        if postID != nil{
            dictionary["post_id"] = postID
        }
        
        if url != nil{
            dictionary["url"] = url
        }
        
        return dictionary
    }
}

struct CustomFieldsJSON
{
    var id : Int!
    var postID : Int!
    var value : String!
    var name : String!
    
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary["id"] as? Int
        postID = dictionary["post_id"] as? Int
        name = dictionary["name"] as? String
        value = dictionary["value"] as? String
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
        
        if postID != nil{
            dictionary["post_id"] = postID
        }
        
        if name != nil{
            dictionary["name"] = name
        }
        
        if value != nil{
            dictionary["value"] = value
        }
        
        
        return dictionary
    }
}
