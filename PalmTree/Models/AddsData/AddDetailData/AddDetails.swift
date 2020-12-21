//
//  AddDetails.swift
//  PalmTree
//
//  Created by SprintSols on 4/7/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AddDetails
{
    var adAuthorId : String!
    var adBidding : String!
    var adCats : [AnyObject]!
    var adCurrency : [AnyObject]!
    var adDate : String!
    var adDesc : String!
    var adId : Int!
    var adPrice : AddDetailAdPrice!
    var adStatus : String!
    var adTags : [AnyObject]!
    var adTagsShow : AddDetailAdTagShow!
    var adTitle : String!
    var adVideo : AddDetailAdVideo!
    var adViewCount : String!
    var authorId : String!
    var expireDate : String!
    var featuredAds : String!
    var fieldsData : [AddDetailFieldsData]!
    var fieldsDataColumn : String!
    var images : [AddDetailImage]!
    var isFeature : Bool!
    var isFeatureText : String!
    var location : AddDetailLocation!
    var locationTop : String!
    var name : String!
    var phone : String!
    var relatedAds : [AddDetailRelatedAd]!
    var sliderImages : [String]!
    
    var adTimer : AddDetailAdTimer!
    var adTypeBar : AddDetailAdTypeBar!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adAuthorId = dictionary["ad_author_id"] as? String
        adBidding = dictionary["ad_bidding"] as? String
        adCats = dictionary["ad_cats"] as? [AnyObject]
        adCurrency = dictionary["ad_currency"] as? [AnyObject]
        adDate = dictionary["ad_date"] as? String
        adDesc = dictionary["ad_desc"] as? String
        adId = dictionary["ad_id"] as? Int
        if let adPriceData = dictionary["ad_price"] as? [String:Any]{
            adPrice = AddDetailAdPrice(fromDictionary: adPriceData)
        }
        adStatus = dictionary["ad_status"] as? String
        adTags = dictionary["ad_tags"] as? [AnyObject]
        if let adTagsShowData = dictionary["ad_tags_show"] as? [String:Any]{
            adTagsShow = AddDetailAdTagShow(fromDictionary: adTagsShowData)
        }
        adTitle = dictionary["ad_title"] as? String
        if let adVideoData = dictionary["ad_video"] as? [String:Any]{
            adVideo = AddDetailAdVideo(fromDictionary: adVideoData)
        }
        adViewCount = dictionary["ad_view_count"] as? String
        authorId = dictionary["author_id"] as? String
        expireDate = dictionary["expire_date"] as? String
        featuredAds = dictionary["featured_ads"] as? String
        fieldsData = [AddDetailFieldsData]()
        if let fieldsDataArray = dictionary["fieldsData"] as? [[String:Any]]{
            for dic in fieldsDataArray{
                let value = AddDetailFieldsData(fromDictionary: dic)
                fieldsData.append(value)
            }
        }
        fieldsDataColumn = dictionary["fieldsData_column"] as? String
        images = [AddDetailImage]()
        if let imagesArray = dictionary["images"] as? [[String:Any]]{
            for dic in imagesArray{
                let value = AddDetailImage(fromDictionary: dic)
                images.append(value)
            }
        }
        isFeature = dictionary["is_feature"] as? Bool
        isFeatureText = dictionary["is_feature_text"] as? String
        if let locationData = dictionary["location"] as? [String:Any]{
            location = AddDetailLocation(fromDictionary: locationData)
        }
        locationTop = dictionary["location_top"] as? String
        name = dictionary["name"] as? String
        phone = dictionary["phone"] as? String
        relatedAds = [AddDetailRelatedAd]()
        if let relatedAdsArray = dictionary["related_ads"] as? [[String:Any]]{
            for dic in relatedAdsArray{
                let value = AddDetailRelatedAd(fromDictionary: dic)
                relatedAds.append(value)
            }
        }
        sliderImages = dictionary["slider_images"] as? [String]
        
        if let adTimerData = dictionary["ad_timer"] as? [String:Any]{
            adTimer = AddDetailAdTimer(fromDictionary: adTimerData)
        }
        if let adTypeBarData = dictionary["ad_type_bar"] as? [String:Any]{
            adTypeBar = AddDetailAdTypeBar(fromDictionary: adTypeBarData)
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
        if adBidding != nil{
            dictionary["ad_bidding"] = adBidding
        }
        if adCats != nil{
            dictionary["ad_cats"] = adCats
        }
        if adCurrency != nil{
            dictionary["ad_currency"] = adCurrency
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
        if adPrice != nil{
            dictionary["ad_price"] = adPrice.toDictionary()
        }
        if adStatus != nil{
            dictionary["ad_status"] = adStatus
        }
        if adTags != nil{
            dictionary["ad_tags"] = adTags
        }
        if adTagsShow != nil{
            dictionary["ad_tags_show"] = adTagsShow.toDictionary()
        }
        if adTitle != nil{
            dictionary["ad_title"] = adTitle
        }
        if adVideo != nil{
            dictionary["ad_video"] = adVideo.toDictionary()
        }
        if adViewCount != nil{
            dictionary["ad_view_count"] = adViewCount
        }
        if authorId != nil{
            dictionary["author_id"] = authorId
        }
        if expireDate != nil{
            dictionary["expire_date"] = expireDate
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds
        }
        if fieldsData != nil{
            var dictionaryElements = [[String:Any]]()
            for fieldsDataElement in fieldsData {
                dictionaryElements.append(fieldsDataElement.toDictionary())
            }
            dictionary["fieldsData"] = dictionaryElements
        }
        if fieldsDataColumn != nil{
            dictionary["fieldsData_column"] = fieldsDataColumn
        }
        if images != nil{
            var dictionaryElements = [[String:Any]]()
            for imagesElement in images {
                dictionaryElements.append(imagesElement.toDictionary())
            }
            dictionary["images"] = dictionaryElements
        }
        if isFeature != nil{
            dictionary["is_feature"] = isFeature
        }
        if isFeatureText != nil{
            dictionary["is_feature_text"] = isFeatureText
        }
        if location != nil{
            dictionary["location"] = location.toDictionary()
        }
        if locationTop != nil{
            dictionary["location_top"] = locationTop
        }
        if name != nil{
            dictionary["name"] = name
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if relatedAds != nil{
            var dictionaryElements = [[String:Any]]()
            for relatedAdsElement in relatedAds {
                dictionaryElements.append(relatedAdsElement.toDictionary())
            }
            dictionary["related_ads"] = dictionaryElements
        }
        if sliderImages != nil{
            dictionary["slider_images"] = sliderImages
        }
        if adTimer != nil{
            dictionary["ad_timer"] = adTimer.toDictionary()
        }
        if adTypeBar != nil{
            dictionary["ad_type_bar"] = adTypeBar.toDictionary()
        }
        return dictionary
    }
    
}

class AdDetailObject: NSObject
{
    var userID : Int!
    var adId : Int!
    var adTitle = ""
    var catID = 0
    var subcatID = 0
    var adCategory  = ""
    var adSubCategory = ""
    var adCurrency = ""
    var adDate = ""
    var adDesc = ""
    var adPrice = ""
    var priceType  = ""
    var maxPrice = ""
    var minPrice = ""
    var images : [UIImage] = [UIImage]()
    var isFeature = false
    var location : AddDetailLocationObject = AddDetailLocationObject()
    var locationTop = ""
    var name = ""
    var phone = ""
    var whatsapp = ""
    var specs = ""
    var sellerType = ""
    var year = ""
    var detailVC = ""
    var motorCatObj : MotorCategoryObject = MotorCategoryObject()
    var propertyCatObj : PropertyCategoryObject = PropertyCategoryObject()
    var objAdPostData = [AdPostField]()
    var adImages : [ImageJSON]!
    var imageIDArray = [Int]()
    var sortType = 1
    var sortTypeText = ""
}

class AddDetailLocationObject: NSObject
{
    var address = ""
    var locName = ""
    var lat : Double!
    var lng : Double!
    var title = ""
    var country = ""
}

class PropertyCategoryObject: NSObject
{
    var bedrooms = ""
    var sellerType = ""
    var propertyType = ""
}

class MotorCategoryObject: NSObject
{
    var regNo = ""
    var sellerType = ""
    var make = ""
    var model = ""
    var year = ""
    var mileage = ""
    var bodyType = ""
    var fuelType = ""
    var transmission = ""
    var colour = ""
    var engineSize = ""
}
