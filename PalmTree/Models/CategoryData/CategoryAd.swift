//
//  CategoryAd.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct CategoryAd{
    
    var adAuthorId : String!
    var ad_Cats : [AnyObject]!
    var adCatsName : String!
    var adDate : String!
    var adId : Int!
    var adPrice : CategoryAdPrice!
    var adSaved : CategoryAdSaved!
    var adStatus : CategoryAdStatus!
    var adTimer : CategoryTimer!
    var adTitle : String!
    var adVideo : CategoryAdVideo!
    var adViews : String!
    var images : [CategoryImage]!
    var location : CategoryLocation!
    var ad_AuthorId : Int!
    var adCats : [CategoryAdCat]!
    var adDesc : String!
    var adImages : [CategoryImage]!
    var adLocation : CategoryLocation!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adAuthorId = dictionary["ad_author_id"] as? String
        ad_Cats = dictionary["ad_cats"] as? [AnyObject]
        adCatsName = dictionary["ad_cats_name"] as? String
        adDate = dictionary["ad_date"] as? String
        adId = dictionary["ad_id"] as? Int
        if let adPriceData = dictionary["ad_price"] as? [String:Any]{
            adPrice = CategoryAdPrice(fromDictionary: adPriceData)
        }
        if let adSavedData = dictionary["ad_saved"] as? [String:Any]{
            adSaved = CategoryAdSaved(fromDictionary: adSavedData)
        }
        if let adStatusData = dictionary["ad_status"] as? [String:Any]{
            adStatus = CategoryAdStatus(fromDictionary: adStatusData)
        }
        if let adTimerData = dictionary["ad_timer"] as? [String:Any]{
            adTimer = CategoryTimer(fromDictionary: adTimerData)
        }
        adTitle = dictionary["ad_title"] as? String
        if let adVideoData = dictionary["ad_video"] as? [String:Any]{
            adVideo = CategoryAdVideo(fromDictionary: adVideoData)
        }
        adViews = dictionary["ad_views"] as? String
        images = [CategoryImage]()
        if let imagesArray = dictionary["images"] as? [[String:Any]]{
            for dic in imagesArray{
                let value = CategoryImage(fromDictionary: dic)
                images.append(value)
            }
        }
        if let locationData = dictionary["location"] as? [String:Any]{
            location = CategoryLocation(fromDictionary: locationData)
        }
        ad_AuthorId = dictionary["ad_author_id"] as? Int
        adCats = [CategoryAdCat]()
        if let adCatsArray = dictionary["ad_cats"] as? [[String:Any]]{
            for dic in adCatsArray{
                let value = CategoryAdCat(fromDictionary: dic)
                adCats.append(value)
            }
        }
        adDesc = dictionary["ad_desc"] as? String
        adImages = [CategoryImage]()
        if let adImagesArray = dictionary["ad_images"] as? [[String:Any]]{
            for dic in adImagesArray{
                let value = CategoryImage(fromDictionary: dic)
                adImages.append(value)
            }
        }
        if let adLocationData = dictionary["ad_location"] as? [String:Any]{
            adLocation = CategoryLocation(fromDictionary: adLocationData)
        }
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
            dictionary["ad_cats"] = adCats
        }
        if adCatsName != nil{
            dictionary["ad_cats_name"] = adCatsName
        }
        if adDate != nil{
            dictionary["ad_date"] = adDate
        }
        if adId != nil{
            dictionary["ad_id"] = adId
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
        if adTimer != nil{
            dictionary["ad_timer"] = adTimer.toDictionary()
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
        if images != nil{
            var dictionaryElements = [[String:Any]]()
            for imagesElement in images {
                dictionaryElements.append(imagesElement.toDictionary())
            }
            dictionary["images"] = dictionaryElements
        }
        if location != nil{
            dictionary["location"] = location.toDictionary()
        }
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
        if adDesc != nil{
            dictionary["ad_desc"] = adDesc
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
        return dictionary
    }
    
}
