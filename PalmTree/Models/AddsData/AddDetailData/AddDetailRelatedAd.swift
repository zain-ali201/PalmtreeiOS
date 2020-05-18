//
//  AddDetailRelatedAd.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetailRelatedAd {
    
    var adAuthorId : Int!
    var adCats : [AddDetailAddCategory]!
    var adCatsName : String!
    var adDate : String!
    var adDesc : String!
    var adId : Int!
    var adImages : [AddDetailImage]!
    var adLocation : AddDetailLocation!
    var adPrice : AddDetailAdPrice!
    var adSaved : AddDetailAddSaved!
    var adStatus : AddDetailAddStatus!
    var adTitle : String!
    var adVideo : AddDetailAdVideo!
    var adViews : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adAuthorId = dictionary["ad_author_id"] as? Int
        adCats = [AddDetailAddCategory]()
        if let adCatsArray = dictionary["ad_cats"] as? [[String:Any]]{
            for dic in adCatsArray{
                let value = AddDetailAddCategory(fromDictionary: dic)
                adCats.append(value)
            }
        }
        adCatsName = dictionary["ad_cats_name"] as? String
        adDate = dictionary["ad_date"] as? String
        adDesc = dictionary["ad_desc"] as? String
        adId = dictionary["ad_id"] as? Int
        adImages = [AddDetailImage]()
        if let adImagesArray = dictionary["ad_images"] as? [[String:Any]]{
            for dic in adImagesArray{
                let value = AddDetailImage(fromDictionary: dic)
                adImages.append(value)
            }
        }
        if let adLocationData = dictionary["ad_location"] as? [String:Any]{
            adLocation = AddDetailLocation(fromDictionary: adLocationData)
        }
        if let adPriceData = dictionary["ad_price"] as? [String:Any]{
            adPrice = AddDetailAdPrice(fromDictionary: adPriceData)
        }
        if let adSavedData = dictionary["ad_saved"] as? [String:Any]{
            adSaved = AddDetailAddSaved(fromDictionary: adSavedData)
        }
        if let adStatusData = dictionary["ad_status"] as? [String:Any]{
            adStatus = AddDetailAddStatus(fromDictionary: adStatusData)
        }
        adTitle = dictionary["ad_title"] as? String
        if let adVideoData = dictionary["ad_video"] as? [String:Any]{
            adVideo = AddDetailAdVideo(fromDictionary: adVideoData)
        }
        adViews = dictionary["ad_views"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adAuthorId != nil{
            dictionary["ad_author_id"] = adAuthorId
        }
        if adCats != nil{
            var dictionaryElements = [[String:Any]]()
            for adCatsElement in adCats {
                dictionaryElements.append(adCatsElement.toDictionary())
            }
            dictionary["ad_cats"] = dictionaryElements
        }
        if adCatsName != nil{
            dictionary["ad_cats_name"] = adCatsName
        }
        if adDate != nil{
            dictionary["ad_date"] = adDate
        }
        if adDesc != nil{
            dictionary["ad_desc"] = adDesc
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
        if adLocation != nil{
            dictionary["ad_location"] = adLocation.toDictionary()
        }
        if adPrice != nil{
            dictionary["ad_price"] = adPrice.toDictionary()
        }
        if adSaved != nil{
            dictionary["ad_saved"] = adSaved.toDictionary()
        }
        if adStatus != nil{
            dictionary["ad_status"] = adStatus.toDictionary()
        }
        if adTitle != nil{
            dictionary["ad_title"] = adTitle
        }
        if adVideo != nil{
            dictionary["ad_video"] = adVideo.toDictionary()
        }
        if adViews != nil{
            dictionary["ad_views"] = adViews
        }
        return dictionary
    }
    
}
