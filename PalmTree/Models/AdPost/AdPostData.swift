//
//  AdPostData.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostData {
    
    var adCatId : Int!
    var adId : Int!
    var adImages : [AdPostImageArray]!
    var btnSubmit : String!
    var fields : [AdPostField]!
    var hideCurrency : [String]!
    var hidePrice : [String]!
    var images : AdPostImage!
    var isUpdate : String!
    var profile : AdPostProfile!
    var title : String!
    var titleFieldName : String!
    var updateNotice : String!
    var catTemplateOn : Bool!
    
    
    
 
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adCatId = dictionary["ad_cat_id"] as? Int
        adId = dictionary["ad_id"] as? Int
        adImages = [AdPostImageArray]()
        if let adImagesArray = dictionary["ad_images"] as? [[String:Any]]{
            for dic in adImagesArray{
                let value = AdPostImageArray(fromDictionary: dic)
                adImages.append(value)
            }
        }
        btnSubmit = dictionary["btn_submit"] as? String
        fields = [AdPostField]()
        if let fieldsArray = dictionary["fields"] as? [[String:Any]]{
            for dic in fieldsArray{
                let value = AdPostField(fromDictionary: dic)
                fields.append(value)
            }
        }
        hideCurrency = dictionary["hide_currency"] as? [String]
        hidePrice = dictionary["hide_price"] as? [String]
        if let imagesData = dictionary["images"] as? [String:Any]{
            images = AdPostImage(fromDictionary: imagesData)
        }
        isUpdate = dictionary["is_update"] as? String
        if let profileData = dictionary["profile"] as? [String:Any]{
            profile = AdPostProfile(fromDictionary: profileData)
        }
        title = dictionary["title"] as? String
        titleFieldName = dictionary["title_field_name"] as? String
        updateNotice = dictionary["update_notice"] as? String
        catTemplateOn = dictionary["cat_template_on"] as? Bool
       
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adCatId != nil{
            dictionary["ad_cat_id"] = adCatId
        }
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        if adImages != nil{
            var dictionaryElements = [[String:Any]]()
            for adImagesElement in adImages {
                dictionaryElements.append(adImagesElement.toDictionary())
            }
            dictionary["ad_images"] = dictionaryElements
        }
        if btnSubmit != nil{
            dictionary["btn_submit"] = btnSubmit
        }
        if fields != nil{
            var dictionaryElements = [[String:Any]]()
            for fieldsElement in fields {
                dictionaryElements.append(fieldsElement.toDictionary())
            }
            dictionary["fields"] = dictionaryElements
        }
        if hideCurrency != nil{
            dictionary["hide_currency"] = hideCurrency
        }
        if hidePrice != nil{
            dictionary["hide_price"] = hidePrice
        }
        if images != nil{
            dictionary["images"] = images.toDictionary()
        }
        if isUpdate != nil{
            dictionary["is_update"] = isUpdate
        }
        if profile != nil{
            dictionary["profile"] = profile.toDictionary()
        }
        if title != nil{
            dictionary["title"] = title
        }
        if titleFieldName != nil{
            dictionary["title_field_name"] = titleFieldName
        }
        if updateNotice != nil{
            dictionary["update_notice"] = updateNotice
        }
        if catTemplateOn != nil{
            dictionary["cat_template_on"] = catTemplateOn
        }
        return dictionary
    }
    
}
