//
//  ProfileDetailsData.swift
//  PalmTree
//
//  Created by SprintSols on 3/26/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct ProfileDetailsData {
    
    var accountType : ProfileDetailsAccountType!
    var accountTypeSelect : [ProfileDetailsAccountTypeSelect]!
    var bumpAds : ProfileDetailsAccountType!
    var bumpAdsIsShow : Bool!
    var displayName : ProfileDetailsAccountType!
    var expireDate : ProfileDetailsAccountType!
    var featuredAds : ProfileDetailsAccountType!
    var id : Int!
    var introduction : ProfileDetailsAccountType!
    var isShowSocial : Bool!
    var location : ProfileDetailsAccountType!
    var packageType : ProfileDetailsAccountType!
    var pageTitle : String!
    var pageTitleEdit : String!
    var phone : ProfileDetailsAccountType!
    var profileExtra : ProfileDetailsExtra!
    var profileImg : ProfileDetailsAccountType!
    var simpleAds : ProfileDetailsAccountType!
    var socialIcons : [ProfileDetailsAccountType]!
    var userEmail : ProfileDetailsAccountType!
    
    var canDeleteAccount : Bool!
    var deleteAccount : ProfileDetailsDeleteAccount!
    
    var blockedUsers : ProfileDetailsAccountType!
    var blockedUsersShow : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let accountTypeData = dictionary["account_type"] as? [String:Any]{
            accountType = ProfileDetailsAccountType(fromDictionary: accountTypeData)
        }
        accountTypeSelect = [ProfileDetailsAccountTypeSelect]()
        if let accountTypeSelectArray = dictionary["account_type_select"] as? [[String:Any]]{
            for dic in accountTypeSelectArray{
                let value = ProfileDetailsAccountTypeSelect(fromDictionary: dic)
                accountTypeSelect.append(value)
            }
        }
        if let bumpAdsData = dictionary["bump_ads"] as? [String:Any]{
            bumpAds = ProfileDetailsAccountType(fromDictionary: bumpAdsData)
        }
        bumpAdsIsShow = dictionary["bump_ads_is_show"] as? Bool
        if let displayNameData = dictionary["display_name"] as? [String:Any]{
            displayName = ProfileDetailsAccountType(fromDictionary: displayNameData)
        }
        if let expireDateData = dictionary["expire_date"] as? [String:Any]{
            expireDate = ProfileDetailsAccountType(fromDictionary: expireDateData)
        }
        if let featuredAdsData = dictionary["featured_ads"] as? [String:Any]{
            featuredAds = ProfileDetailsAccountType(fromDictionary: featuredAdsData)
        }
        id = dictionary["id"] as? Int
        if let introductionData = dictionary["introduction"] as? [String:Any]{
            introduction = ProfileDetailsAccountType(fromDictionary: introductionData)
        }
        isShowSocial = dictionary["is_show_social"] as? Bool
        if let locationData = dictionary["location"] as? [String:Any]{
            location = ProfileDetailsAccountType(fromDictionary: locationData)
        }
        if let packageTypeData = dictionary["package_type"] as? [String:Any]{
            packageType = ProfileDetailsAccountType(fromDictionary: packageTypeData)
        }
        pageTitle = dictionary["page_title"] as? String
        pageTitleEdit = dictionary["page_title_edit"] as? String
        if let phoneData = dictionary["phone"] as? [String:Any]{
            phone = ProfileDetailsAccountType(fromDictionary: phoneData)
        }
        if let profileExtraData = dictionary["profile_extra"] as? [String:Any]{
            profileExtra = ProfileDetailsExtra(fromDictionary: profileExtraData)
        }
        if let profileImgData = dictionary["profile_img"] as? [String:Any]{
            profileImg = ProfileDetailsAccountType(fromDictionary: profileImgData)
        }
        if let simpleAdsData = dictionary["simple_ads"] as? [String:Any]{
            simpleAds = ProfileDetailsAccountType(fromDictionary: simpleAdsData)
        }
        socialIcons = [ProfileDetailsAccountType]()
        if let socialIconsArray = dictionary["social_icons"] as? [[String:Any]]{
            for dic in socialIconsArray{
                let value = ProfileDetailsAccountType(fromDictionary: dic)
                socialIcons.append(value)
            }
        }
        if let userEmailData = dictionary["user_email"] as? [String:Any]{
            userEmail = ProfileDetailsAccountType(fromDictionary: userEmailData)
        }
        
        canDeleteAccount = dictionary["can_delete_account"] as? Bool
       
        if let deleteAccountData = dictionary["delete_account"] as? [String:Any] {
            deleteAccount = ProfileDetailsDeleteAccount(fromDictionary: deleteAccountData)
        }
        
        if let blockedUsersData = dictionary["blocked_users"] as? [String:Any]{
            blockedUsers = ProfileDetailsAccountType(fromDictionary: blockedUsersData)
        }
        blockedUsersShow = dictionary["blocked_users_show"] as? Bool
        
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accountType != nil{
            dictionary["account_type"] = accountType.toDictionary()
        }
        if accountTypeSelect != nil{
            var dictionaryElements = [[String:Any]]()
            for accountTypeSelectElement in accountTypeSelect {
                dictionaryElements.append(accountTypeSelectElement.toDictionary())
            }
            dictionary["account_type_select"] = dictionaryElements
        }
        if bumpAds != nil{
            dictionary["bump_ads"] = bumpAds.toDictionary()
        }
        if bumpAdsIsShow != nil{
            dictionary["bump_ads_is_show"] = bumpAdsIsShow
        }
        if displayName != nil{
            dictionary["display_name"] = displayName.toDictionary()
        }
        if expireDate != nil{
            dictionary["expire_date"] = expireDate.toDictionary()
        }
        if featuredAds != nil{
            dictionary["featured_ads"] = featuredAds.toDictionary()
        }
        if id != nil{
            dictionary["id"] = id
        }
        if introduction != nil{
            dictionary["introduction"] = introduction.toDictionary()
        }
        if isShowSocial != nil{
            dictionary["is_show_social"] = isShowSocial
        }
        if location != nil{
            dictionary["location"] = location.toDictionary()
        }
        if packageType != nil{
            dictionary["package_type"] = packageType.toDictionary()
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if pageTitleEdit != nil{
            dictionary["page_title_edit"] = pageTitleEdit
        }
        if phone != nil{
            dictionary["phone"] = phone.toDictionary()
        }
        if profileExtra != nil{
            dictionary["profile_extra"] = profileExtra.toDictionary()
        }
        if profileImg != nil{
            dictionary["profile_img"] = profileImg.toDictionary()
        }
        if simpleAds != nil{
            dictionary["simple_ads"] = simpleAds.toDictionary()
        }
        if socialIcons != nil{
            var dictionaryElements = [[String:Any]]()
            for socialIconsElement in socialIcons {
                dictionaryElements.append(socialIconsElement.toDictionary())
            }
            dictionary["social_icons"] = dictionaryElements
        }
        if userEmail != nil{
            dictionary["user_email"] = userEmail.toDictionary()
        }
        
        if canDeleteAccount != nil{
            dictionary["can_delete_account"] = canDeleteAccount
        }
        
        if deleteAccount != nil{
            dictionary["delete_account"] = deleteAccount.toDictionary()
        }
        
        if blockedUsers != nil{
            dictionary["blocked_users"] = blockedUsers.toDictionary()
        }
        if blockedUsersShow != nil{
            dictionary["blocked_users_show"] = blockedUsersShow
        }
        
        return dictionary
    }
    
}
