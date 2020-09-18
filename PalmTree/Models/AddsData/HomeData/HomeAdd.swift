//
//  HomeAdd.swift
//  PalmTree
//
//  Created by SprintSols on 4/18/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct HomeAdd{
    
    var adAuthorId : Int!
    var adCats : [AddCat]!
    var adCatsName : String!
    var adDate : String!
    var adDesc : String!
    var adId : Int!
    var adImages : [AddImage]!
    var adLocation : AddLocation!
    var adPrice : AddPrice!
    var adSaved : AddSaved!
    var adStatus : AddStatus!
    var adTimer : AddTimer!
    var adTitle : String!
    var adVideo : AddVideo!
    var adViews : String!
    var ad_Id : String!
    var bannerId : String!
    var interstitalId : String!
    var isShowBanner : Bool!
    var isShowInitial : Bool!
    var position : String!
    var show : Bool!
    var time : String!
    var timeInitial : String!
    var type : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adAuthorId = dictionary["ad_author_id"] as? Int
        adCats = [AddCat]()
        if let adCatsArray = dictionary["ad_cats"] as? [[String:Any]]{
            for dic in adCatsArray{
                let value = AddCat(fromDictionary: dic)
                adCats.append(value)
            }
        }
        adCatsName = dictionary["ad_cats_name"] as? String
        adDate = dictionary["ad_date"] as? String
        adDesc = dictionary["ad_desc"] as? String
        adId = dictionary["ad_id"] as? Int
        adImages = [AddImage]()
        if let adImagesArray = dictionary["ad_images"] as? [[String:Any]]{
            for dic in adImagesArray{
                let value = AddImage(fromDictionary: dic)
                adImages.append(value)
            }
        }
        if let adLocationData = dictionary["ad_location"] as? [String:Any]{
            adLocation = AddLocation(fromDictionary: adLocationData)
        }
        if let adPriceData = dictionary["ad_price"] as? [String:Any]{
            adPrice = AddPrice(fromDictionary: adPriceData)
        }
        if let adSavedData = dictionary["ad_saved"] as? [String:Any]{
            adSaved = AddSaved(fromDictionary: adSavedData)
        }
        if let adStatusData = dictionary["ad_status"] as? [String:Any]{
            adStatus = AddStatus(fromDictionary: adStatusData)
        }
        if let adTimerData = dictionary["ad_timer"] as? [String:Any]{
            adTimer = AddTimer(fromDictionary: adTimerData)
        }
        adTitle = dictionary["ad_title"] as? String
        if let adVideoData = dictionary["ad_video"] as? [String:Any]{
            adVideo = AddVideo(fromDictionary: adVideoData)
        }
        adViews = dictionary["ad_views"] as? String
        ad_Id = dictionary["ad_id"] as? String
        bannerId = dictionary["banner_id"] as? String
        interstitalId = dictionary["interstital_id"] as? String
        isShowBanner = dictionary["is_show_banner"] as? Bool
        isShowInitial = dictionary["is_show_initial"] as? Bool
        position = dictionary["position"] as? String
        show = dictionary["show"] as? Bool
        time = dictionary["time"] as? String
        timeInitial = dictionary["time_initial"] as? String
        type = dictionary["type"] as? String
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
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        if bannerId != nil{
            dictionary["banner_id"] = bannerId
        }
        if interstitalId != nil{
            dictionary["interstital_id"] = interstitalId
        }
        if isShowBanner != nil{
            dictionary["is_show_banner"] = isShowBanner
        }
        if isShowInitial != nil{
            dictionary["is_show_initial"] = isShowInitial
        }
        if position != nil{
            dictionary["position"] = position
        }
        if show != nil{
            dictionary["show"] = show
        }
        if time != nil{
            dictionary["time"] = time
        }
        if timeInitial != nil{
            dictionary["time_initial"] = timeInitial
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}
