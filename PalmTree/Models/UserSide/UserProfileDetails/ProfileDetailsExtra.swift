//
//  ProfileDetailsExtra.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsExtra {
    
    var adsExpired : String!
    var adsFeatured : String!
    var adsInactive : String!
    var adsSold : String!
    var adsTotal : String!
    var displayName : String!
    var editText : String!
    var expireAds : String!
    var featuredAds : String!
    var id : Int!
    var isShowSocial : Bool!
    var lastLogin : String!
    var packageType : String!
    var phone : String!
    var profileImg : String!
    var rateBar : ProfileDetailsRateBar!
    var simpleAds : String!
    var socialIcons : [ProfileDetailsAccountType]!
    
    var userEmail : String!
    var verifyButon : ProfileDetailsVerifyButton!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adsExpired = dictionary["ads_expired"] as? String
        adsFeatured = dictionary["ads_featured"] as? String
        adsInactive = dictionary["ads_inactive"] as? String
        adsSold = dictionary["ads_sold"] as? String
        adsTotal = dictionary["ads_total"] as? String
        displayName = dictionary["display_name"] as? String
        editText = dictionary["edit_text"] as? String
        expireAds = dictionary["expire_ads"] as? String
        featuredAds = dictionary["featured_ads"] as? String
        id = dictionary["id"] as? Int
        isShowSocial = dictionary["is_show_social"] as? Bool
        lastLogin = dictionary["last_login"] as? String
        packageType = dictionary["package_type"] as? String
        phone = dictionary["phone"] as? String
        profileImg = dictionary["profile_img"] as? String
        if let rateBarData = dictionary["rate_bar"] as? [String:Any]{
            rateBar = ProfileDetailsRateBar(fromDictionary: rateBarData)
        }
        simpleAds = dictionary["simple_ads"] as? String
        socialIcons = [ProfileDetailsAccountType]()
        if let socialIconsArray = dictionary["social_icons"] as? [[String:Any]]{
            for dic in socialIconsArray{
                let value = ProfileDetailsAccountType(fromDictionary: dic)
                socialIcons.append(value)
            }
        }
        userEmail = dictionary["user_email"] as? String
        if let verifyButonData = dictionary["verify_buton"] as? [String:Any]{
            verifyButon = ProfileDetailsVerifyButton(fromDictionary: verifyButonData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adsExpired != nil{
            dictionary["ads_expired"] = adsExpired
        }
        if adsFeatured != nil{
            dictionary["ads_featured"] = adsFeatured
        }
        if adsInactive != nil{
            dictionary["ads_inactive"] = adsInactive
        }
        if adsSold != nil{
            dictionary["ads_sold"] = adsSold
        }
        if adsTotal != nil{
            dictionary["ads_total"] = adsTotal
        }
        if displayName != nil{
            dictionary["display_name"] = displayName
        }
        if editText != nil{
            dictionary["edit_text"] = editText
        }
        if expireAds != nil{
            dictionary["expire_ads"] = expireAds
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isShowSocial != nil{
            dictionary["is_show_social"] = isShowSocial
        }
        if lastLogin != nil{
            dictionary["last_login"] = lastLogin
        }
        if packageType != nil{
            dictionary["package_type"] = packageType
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if profileImg != nil{
            dictionary["profile_img"] = profileImg
        }
        if rateBar != nil{
            dictionary["rate_bar"] = rateBar.toDictionary()
        }
        if simpleAds != nil{
            dictionary["simple_ads"] = simpleAds
        }
        if socialIcons != nil{
            var dictionaryElements = [[String:Any]]()
            for socialIconsElement in socialIcons {
                dictionaryElements.append(socialIconsElement.toDictionary())
            }
            dictionary["social_icons"] = dictionaryElements
        }
        if userEmail != nil{
            dictionary["user_email"] = userEmail
        }
        if verifyButon != nil{
            dictionary["verify_buton"] = verifyButon.toDictionary()
        }
        return dictionary
    }
    
}
