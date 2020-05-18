//
//  AdPostProfile.swift
//  PalmTree
//
//  Created by SprintSols on 4/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct AdPostProfile {
    
  
    var adCountry : AdPostAdCountry!
    var adCountryShow : Bool!
    var bumpAdIsShow : Bool!
    var featuredAdBuy : Bool!
    var featuredAdIsShow : Bool!
    var featuredAd : AdPostField!
    var featuredAdText : AdPostBumpAdText!
    var featuredAdNotify : AdPostFeaturedAdNotify!
    var isPhoneVerificationOn : Bool!
    var location : AdPostField!
    var map : AdPostMap!
    var name : AdPostField!
    var phone : AdPostField!
    var phoneEditable : Bool!
    var bumpAd: AdPostBumpAdd!
    
    var bumpAdText : AdPostFeaturedAdText!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let adCountryData = dictionary["ad_country"] as? [String:Any]{
            adCountry = AdPostAdCountry(fromDictionary: adCountryData)
        }
        adCountryShow = dictionary["ad_country_show"] as? Bool
        bumpAdIsShow = dictionary["bump_ad_is_show"] as? Bool
        featuredAdBuy = dictionary["featured_ad_buy"] as? Bool
        featuredAdIsShow = dictionary["featured_ad_is_show"] as? Bool
        if let featuredAdNotifyData = dictionary["featured_ad_notify"] as? [String:Any]{
            featuredAdNotify = AdPostFeaturedAdNotify(fromDictionary: featuredAdNotifyData)
        }
        isPhoneVerificationOn = dictionary["is_phone_verification_on"] as? Bool
        if let locationData = dictionary["location"] as? [String:Any]{
            location = AdPostField(fromDictionary: locationData)
        }
        if let mapData = dictionary["map"] as? [String:Any]{
            map = AdPostMap(fromDictionary: mapData)
        }
        if let nameData = dictionary["name"] as? [String:Any]{
            name = AdPostField(fromDictionary: nameData)
        }
        if let phoneData = dictionary["phone"] as? [String:Any]{
            phone = AdPostField(fromDictionary: phoneData)
        }
        phoneEditable = dictionary["phone_editable"] as? Bool
        
        if let featuredAdTextData = dictionary["featured_ad_text"] as? [String:Any]{
            featuredAdText = AdPostBumpAdText(fromDictionary: featuredAdTextData)
        }
        if let featuredAdData = dictionary["featured_ad"] as? [String:Any]{
            featuredAd = AdPostField(fromDictionary: featuredAdData)
        }
        
        if let bumpAdData = dictionary["bump_ad"] as? [String: Any] {
            bumpAd = AdPostBumpAdd(fromDictionary: bumpAdData)
        }
        
        if let bumpAdTextData = dictionary["bump_ad_text"] as? [String: Any] {
            bumpAdText = AdPostFeaturedAdText(fromDictionary: bumpAdTextData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adCountry != nil{
            dictionary["ad_country"] = adCountry.toDictionary()
        }
        if adCountryShow != nil{
            dictionary["ad_country_show"] = adCountryShow
        }
        if bumpAdIsShow != nil{
            dictionary["bump_ad_is_show"] = bumpAdIsShow
        }
        if featuredAdBuy != nil{
            dictionary["featured_ad_buy"] = featuredAdBuy
        }
        if featuredAdIsShow != nil{
            dictionary["featured_ad_is_show"] = featuredAdIsShow
        }
        if featuredAdNotify != nil{
            dictionary["featured_ad_notify"] = featuredAdNotify.toDictionary()
        }
        if isPhoneVerificationOn != nil{
            dictionary["is_phone_verification_on"] = isPhoneVerificationOn
        }
        if location != nil{
            dictionary["location"] = location.toDictionary()
        }
        if map != nil{
            dictionary["map"] = map.toDictionary()
        }
        if name != nil{
            dictionary["name"] = name.toDictionary()
        }
        if phone != nil{
            dictionary["phone"] = phone.toDictionary()
        }
        if phoneEditable != nil{
            dictionary["phone_editable"] = phoneEditable
        }
        if featuredAdText != nil{
            dictionary["featured_ad_text"] = featuredAdText.toDictionary()
        }
        if featuredAd != nil{
            dictionary["featured_ad"] = featuredAd.toDictionary()
        }
        if bumpAd != nil {
            dictionary["bump_ad"] = bumpAd.toDictionary()
        }
        return dictionary
    }
    
}
